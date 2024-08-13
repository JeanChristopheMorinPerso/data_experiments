extern "C"
{
#include <postgres.h>
#include <fmgr.h>
#include <access/hash.h>
#include <utils/builtins.h>
#include <varatt.h>

#ifdef PG_MODULE_MAGIC
  PG_MODULE_MAGIC;
#endif

extern Datum condaversion_in (PG_FUNCTION_ARGS);
extern Datum condaversion_out (PG_FUNCTION_ARGS);
extern Datum condaversion_cmp (PG_FUNCTION_ARGS);
extern Datum condaversion_hash (PG_FUNCTION_ARGS);
extern Datum condaversion_eq (PG_FUNCTION_ARGS);
extern Datum condaversion_ne (PG_FUNCTION_ARGS);
extern Datum condaversion_gt (PG_FUNCTION_ARGS);
extern Datum condaversion_ge (PG_FUNCTION_ARGS);
extern Datum condaversion_lt (PG_FUNCTION_ARGS);
extern Datum condaversion_le (PG_FUNCTION_ARGS);
//   extern Datum condaversion_smaller (PG_FUNCTION_ARGS);
//   extern Datum condaversion_larger (PG_FUNCTION_ARGS);
}

#include <iostream>

#include <mamba/specs/version.hpp>
#include <mamba/util/string.hpp>

namespace
{

    typedef struct CondaVersion {
        int32 length;  // Header
        char data[FLEXIBLE_ARRAY_MEMBER];
    } CondaVersion;

    int32
    condaversioncmp (char *left, char *right)
    {
        int32 result;
        // char *lstr, *rstr;

        // lstr = text_to_cstring(left);
        // rstr = text_to_cstring(right);

        mamba::specs::Version left_version = mamba::specs::Version::parse(left).value();
        mamba::specs::Version right_version = mamba::specs::Version::parse(right).value();

        if (left_version > right_version) {
            result = 1;
        } else if (left_version < right_version) {
            result = -1;
        } else {
            result = 0;
        }

        // pfree (lstr);
        // pfree (rstr);

        return (result);
    }
}

extern "C"
{
    PG_FUNCTION_INFO_V1(condaversion_in);

    Datum
    condaversion_in(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_in");
        char *str = PG_GETARG_CSTRING(0);

        auto tmp_version = mamba::specs::Version::parse(str);

        if (!tmp_version.has_value())
            ereport(ERROR,
                    (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                    errmsg("invalid input syntax for type %s: \"%s\". Error from libmamba: %s",
                            "condaversion", str, tmp_version.error().what())));
        // pfree(str);

        // Allocate on the heap. We get a pointer to it. This guarantees that
        // it won't be freed after the return. (I think?)
        // I have no idea how it'll be freed...
        // Should we create a strut instead that we could palloc?
        // mamba::specs::Version *version = new mamba::specs::Version(
        //     tmp_version.value().epoch(),
        //     std::move(tmp_version.value().version()),
        //     std::move(tmp_version.value().local())
        // );

        // Add one for the null terminator.
        std::size_t length = std::strlen(str) + 1;

        CondaVersion *destination = (CondaVersion *) palloc(VARHDRSZ + length);
        SET_VARSIZE(destination, VARHDRSZ + length);
        memcpy(destination->data, str, length);

        PG_RETURN_POINTER(destination);
    }

    PG_FUNCTION_INFO_V1(condaversion_out);

    Datum
    condaversion_out(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_out");
        // mamba::specs::Version *version = (mamba::specs::Version *) PG_GETARG_POINTER(0);

        CondaVersion *version = (CondaVersion *) PG_GETARG_POINTER(0);

        // Returning version.str().c_str() will cause problems. For example,
        // a first query like "SELECT '1.2'::condaversion;" will result in
        // '\x08'...
        // So it looks like we really need to palloc the string.
        // https://stackoverflow.com/a/42168751
        // char *cstr = (char *)palloc( (std::strlen(version)) * sizeof (char));
        // strcpy(cstr, version);

        char       *result;
        result = psprintf("%s", version->data);

        PG_RETURN_CSTRING(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_hash);

    Datum
    condaversion_hash(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_hash");
        mamba::specs::Version *version = (mamba::specs::Version *) PG_GETARG_POINTER(0);

        Datum result;

        // TODO: Maybe use std::hash like in https://github.com/mamba-org/mamba/blob/main/libmamba/include/mamba/specs/version_spec.hpp#L260?
        std::string str = version->str();
        char *cstr = str.data();

        result = hash_any((unsigned char *) cstr, std::strlen(cstr));
        pfree(cstr);

        // PG_FREE_IF_COPY(&version, 0);

        PG_RETURN_DATUM(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_cmp);

    Datum
    condaversion_cmp(PG_FUNCTION_ARGS)
    {
        CondaVersion *left = (CondaVersion *) PG_GETARG_POINTER(0);
        CondaVersion *right = (CondaVersion *) PG_GETARG_POINTER(1);
        int32 result;

        // mamba::specs::Version left = mamba::specs::Version::parse(left_intern->data).value();
        // mamba::specs::Version right = mamba::specs::Version::parse(right_intern->data).value();
        result = condaversioncmp(left->data, right->data);

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_INT32(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_eq);

    Datum
    condaversion_eq(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_eq");
        // mamba::specs::Version *left = (mamba::specs::Version *) PG_GETARG_POINTER(0);
        // mamba::specs::Version *right = (mamba::specs::Version *) PG_GETARG_POINTER(1);
        CondaVersion *left = (CondaVersion *) PG_GETARG_POINTER(0);
        CondaVersion *right = (CondaVersion *) PG_GETARG_POINTER(1);

        // auto left = mamba::specs::Version::parse(left_intern->data).value();
        // auto right = mamba::specs::Version::parse(right_intern->data).value();
        int32 result;

        result = condaversioncmp(left->data, right->data) == 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    ////////

    PG_FUNCTION_INFO_V1(condaversion_ne);

    Datum
    condaversion_ne(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_ne");
        // mamba::specs::Version *left = (mamba::specs::Version *) PG_GETARG_POINTER(0);
        // mamba::specs::Version *right = (mamba::specs::Version *) PG_GETARG_POINTER(1);
        CondaVersion *left = (CondaVersion *) PG_GETARG_POINTER(0);
        CondaVersion *right = (CondaVersion *) PG_GETARG_POINTER(1);
        int32 result;

        result = condaversioncmp(left->data, right->data) != 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_lt);

    Datum
    condaversion_lt(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_lt");
        // mamba::specs::Version *left = (mamba::specs::Version *) PG_GETARG_POINTER(0);
        // mamba::specs::Version *right = (mamba::specs::Version *) PG_GETARG_POINTER(1);
        CondaVersion *left = (CondaVersion *) PG_GETARG_POINTER(0);
        CondaVersion *right = (CondaVersion *) PG_GETARG_POINTER(1);
        int32 result;

        result = condaversioncmp(left->data, right->data) < 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_le);

    Datum
    condaversion_le(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_le");
        // mamba::specs::Version *left = (mamba::specs::Version *) PG_GETARG_POINTER(0);
        // mamba::specs::Version *right = (mamba::specs::Version *) PG_GETARG_POINTER(1);
        CondaVersion *left = (CondaVersion *) PG_GETARG_POINTER(0);
        CondaVersion *right = (CondaVersion *) PG_GETARG_POINTER(1);
        int32 result;

        result = condaversioncmp(left->data, right->data) <= 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_gt);

    Datum
    condaversion_gt(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_gt");
        // mamba::specs::Version *left = (mamba::specs::Version *) PG_GETARG_POINTER(0);
        // mamba::specs::Version *right = (mamba::specs::Version *) PG_GETARG_POINTER(1);
        CondaVersion *left = (CondaVersion *) PG_GETARG_POINTER(0);
        CondaVersion *right = (CondaVersion *) PG_GETARG_POINTER(1);
        int32 result;

        result = condaversioncmp(left->data, right->data) > 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_ge);

    Datum
    condaversion_ge(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_ge");
        // mamba::specs::Version *left = (mamba::specs::Version *) PG_GETARG_POINTER(0);
        // mamba::specs::Version *right = (mamba::specs::Version *) PG_GETARG_POINTER(1);
        CondaVersion *left = (CondaVersion *) PG_GETARG_POINTER(0);
        CondaVersion *right = (CondaVersion *) PG_GETARG_POINTER(1);
        int32 result;

        result = condaversioncmp(left->data, right->data) >= 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

}
