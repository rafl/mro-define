#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static HV *mros;

static AV *
resolve (pTHX_ HV *stash, U32 level)
{
	dSP;
	I32 count;
	SV *tmp, **callback;
	AV *ret;
	struct mro_meta *meta;
	const struct mro_alg *alg;

	meta = HvMROMETA (stash);
	alg = meta->mro_which;

	if (!(callback = hv_fetch (mros, alg->name, alg->length, 0))) {
		croak ("failed to find callback for mro %s", alg->name);
	}

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);
	EXTEND (SP, 2);
	mPUSHs (newRV_inc ((SV *)stash));
	mPUSHu (level);
	PUTBACK;

	count = call_sv (*callback, G_SCALAR);

	if (count != 1) {
		croak ("mro resolver didn't return exactly one value");
	}

	SPAGAIN;
	tmp = POPs;

	if (!SvROK (tmp) || (SvTYPE (SvRV (tmp)) != SVt_PVAV)) {
		croak ("mro resolver didn't return an array reference");
	}

	ret = (AV *)SvRV (tmp);
	SvREFCNT_inc (ret);

	PUTBACK;
	FREETMPS;
	LEAVE;

	return ret;
}

MODULE = MRO::Define  PACKAGE = MRO::Define

PROTOTYPES: DISABLE

void
register_mro (name, resolve_cb, kflags=0)
		SV *name
		SV *resolve_cb
		U16 kflags
	PREINIT:
		struct mro_alg *mro;
		const char *name_pv;
		STRLEN name_len;
	INIT:
		if (!SvROK (resolve_cb) || (SvTYPE (SvRV (resolve_cb)) != SVt_PVCV)) {
			croak ("resolve_cb is not a code reference");
		}

		name_pv = SvPV (name, name_len);

		Newxz (mro, 1, struct mro_alg);
		mro->name = strdup (name_pv);
		mro->length = name_len;
		mro->kflags = kflags;
		mro->resolve = resolve;
	CODE:
		if (!hv_store (mros, name_pv, name_len, newSVsv (resolve_cb), 0)) {
			croak ("failed to store hash value");
		}
		Perl_mro_register (aTHX_ mro);

BOOT:
	mros = newHV ();
