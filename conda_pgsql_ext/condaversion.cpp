extern "C"
{
#include <postgres.h>
#include <fmgr.h>
#include <access/hash.h>
#include <utils/builtins.h>
#include <varatt.h>
#include <utils/jsonb.h>
#include <utils/numeric.h>

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

static const char* CONDA_JSON_KEY_EPOCH = "e";
static const char* CONDA_JSON_KEY_VERSION = "v";
static const char* CONDA_JSON_KEY_LOCAL = "l";
static const char* CONDA_JSON_KEY_LITERAL = "l";
static const char* CONDA_JSON_KEY_NUMERAL = "n";
static const char* CONDA_JSON_KEY_ORIGINAL = "o";

namespace
{
    int32
    condaversioncmp (mamba::specs::Version* left, mamba::specs::Version* right)
    {
        int32 result;
        if (left > right) {
            result = 1;
        } else if (left < right) {
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
    Jsonb* cpp_version_to_jsonb(mamba::specs::Version *version, char* raw_version) {
        // Create a new JSON object
        JsonbParseState *parseState = NULL;
        JsonbValue *result = pushJsonbValue(&parseState, WJB_BEGIN_OBJECT, NULL);

        // Add epoch
        JsonbValue epochKey, epochVal;
        epochKey.type = jbvString;
        epochKey.val.string.val = (char*)CONDA_JSON_KEY_EPOCH;
        epochKey.val.string.len = std::strlen(CONDA_JSON_KEY_EPOCH);
        epochVal.type = jbvNumeric;
        epochVal.val.numeric = DatumGetNumeric(DirectFunctionCall1(int4_numeric, Int32GetDatum(version->epoch())));
        result = pushJsonbValue(&parseState, WJB_KEY, &epochKey);
        result = pushJsonbValue(&parseState, WJB_VALUE, &epochVal);

        // Add version array
        JsonbValue versionKey;
        versionKey.type = jbvString;
        versionKey.val.string.val = (char*)CONDA_JSON_KEY_VERSION;
        versionKey.val.string.len = std::strlen(CONDA_JSON_KEY_VERSION);
        result = pushJsonbValue(&parseState, WJB_KEY, &versionKey);
        // elog(NOTICE, "Opening version array");
        result = pushJsonbValue(&parseState, WJB_BEGIN_ARRAY, NULL);

        for (const auto& part : version->version())
        {
            // elog(NOTICE, "  Opening part array");
            result = pushJsonbValue(&parseState, WJB_BEGIN_ARRAY, NULL);
            for (const auto& atom : part) {

                result = pushJsonbValue(&parseState, WJB_BEGIN_OBJECT, NULL);

                JsonbValue atomLiteralKey, atomLiteralVal;
                atomLiteralKey.type = jbvString;
                atomLiteralKey.val.string.val = (char*)CONDA_JSON_KEY_LITERAL;
                atomLiteralKey.val.string.len = std::strlen(CONDA_JSON_KEY_LITERAL);
                atomLiteralVal.type = jbvString;
                atomLiteralVal.val.string.val = (char*)atom.literal().c_str();
                atomLiteralVal.val.string.len = atom.literal().length();
                result = pushJsonbValue(&parseState, WJB_KEY, &atomLiteralKey);
                result = pushJsonbValue(&parseState, WJB_VALUE, &atomLiteralVal);

                JsonbValue atomNumeralKey, atomNumeralVal;
                atomNumeralKey.type = jbvString;
                atomNumeralKey.val.string.val = (char*)CONDA_JSON_KEY_NUMERAL;
                atomNumeralKey.val.string.len = std::strlen(CONDA_JSON_KEY_NUMERAL);
                atomNumeralVal.type = jbvNumeric;
                atomNumeralVal.val.numeric = DatumGetNumeric(DirectFunctionCall1(int8_numeric, Int64GetDatum(atom.numeral())));
                result = pushJsonbValue(&parseState, WJB_KEY, &atomNumeralKey);
                result = pushJsonbValue(&parseState, WJB_VALUE, &atomNumeralVal);

                result = pushJsonbValue(&parseState, WJB_END_OBJECT, NULL);
            }

            result = pushJsonbValue(&parseState, WJB_END_ARRAY, NULL);
            // elog(NOTICE, "  Closing part array");
        }

        // elog(NOTICE, "Closing version array");
        result = pushJsonbValue(&parseState, WJB_END_ARRAY, NULL);

        // Add local array
        JsonbValue localKey;
        localKey.type = jbvString;
        localKey.val.string.val = (char*)CONDA_JSON_KEY_LOCAL;
        localKey.val.string.len = std::strlen(CONDA_JSON_KEY_LOCAL);
        result = pushJsonbValue(&parseState, WJB_KEY, &localKey);
        // elog(NOTICE, "Opening local array");
        result = pushJsonbValue(&parseState, WJB_BEGIN_ARRAY, NULL);

        for (const auto& part : version->local())
        {
            // elog(NOTICE, "  Opening part array");
            result = pushJsonbValue(&parseState, WJB_BEGIN_ARRAY, NULL);
            for (const auto& atom : part) {

                result = pushJsonbValue(&parseState, WJB_BEGIN_OBJECT, NULL);

                JsonbValue atomLiteralKey, atomLiteralVal;
                atomLiteralKey.type = jbvString;
                atomLiteralKey.val.string.val = (char*)CONDA_JSON_KEY_LITERAL;
                atomLiteralKey.val.string.len = std::strlen(CONDA_JSON_KEY_LITERAL);
                atomLiteralVal.type = jbvString;
                atomLiteralVal.val.string.val = (char*)atom.literal().c_str();
                atomLiteralVal.val.string.len = atom.literal().length();
                result = pushJsonbValue(&parseState, WJB_KEY, &atomLiteralKey);
                result = pushJsonbValue(&parseState, WJB_VALUE, &atomLiteralVal);

                JsonbValue atomNumeralKey, atomNumeralVal;
                atomNumeralKey.type = jbvString;
                atomNumeralKey.val.string.val = (char*)CONDA_JSON_KEY_NUMERAL;
                atomNumeralKey.val.string.len = std::strlen(CONDA_JSON_KEY_NUMERAL);
                atomNumeralVal.type = jbvNumeric;
                atomNumeralVal.val.numeric = DatumGetNumeric(DirectFunctionCall1(int8_numeric, Int64GetDatum(atom.numeral())));
                result = pushJsonbValue(&parseState, WJB_KEY, &atomNumeralKey);
                result = pushJsonbValue(&parseState, WJB_VALUE, &atomNumeralVal);

                result = pushJsonbValue(&parseState, WJB_END_OBJECT, NULL);
            }

            // elog(NOTICE, "  Closing part array");
            result = pushJsonbValue(&parseState, WJB_END_ARRAY, NULL);
        }

        // elog(NOTICE, "Closing local array");
        result = pushJsonbValue(&parseState, WJB_END_ARRAY, NULL);

        // Add original version for display purposes
        JsonbValue originalKey, originalVal;
        originalKey.type = jbvString;
        originalKey.val.string.val = (char*)CONDA_JSON_KEY_ORIGINAL;
        originalKey.val.string.len = std::strlen(CONDA_JSON_KEY_ORIGINAL);
        originalVal.type = jbvString;
        originalVal.val.string.val = raw_version;
        originalVal.val.string.len = strlen(raw_version);
        result = pushJsonbValue(&parseState, WJB_KEY, &originalKey);
        result = pushJsonbValue(&parseState, WJB_VALUE, &originalVal);

        result = pushJsonbValue(&parseState, WJB_END_OBJECT, NULL);

        return JsonbValueToJsonb(result);
    }

    const char * const CONDA_PSQL_TYPES_STR[] =
    {
        "WJB_DONE",
        "WJB_KEY",
        "WJB_VALUE",
        "WJB_ELEM",
        "WJB_BEGIN_ARRAY",
        "WJB_END_ARRAY",
        "WJB_BEGIN_OBJECT",
        "WJB_END_OBJECT"
    };

    // Get a CommonVersion out of a Jsonb.
    // This function is messy...
    mamba::specs::CommonVersion process_conda_jsonb_attr(Jsonb* jsonb, const char* attr_name) {
        JsonbValue attr_value;
        getKeyJsonValueFromContainer(&jsonb->root, attr_name, strlen(attr_name), &attr_value);
        Assert(attr_value.type == jbvBinary);

        // This is binary, but we can get the actual container via attr_value.val.binary.data
        Assert(JsonContainerIsArray(attr_value.val.binary.data));

        JsonbIterator *it = JsonbIteratorInit(attr_value.val.binary.data);
        JsonbIteratorToken type;
        JsonbValue val;

        mamba::specs::CommonVersion parts = mamba::specs::CommonVersion();

        // elog(NOTICE, "Iterating over %d parts", JsonContainerSize(attr_value.val.binary.data));

        int indentation = 0;
        bool processingAtom = false;

        mamba::specs::VersionPart part;

        std::string literal;
        int64_t numeral = 0;

        while ((type = JsonbIteratorNext(&it, &val, false)) != WJB_DONE) {
            if ((type == WJB_END_ARRAY) || (type == WJB_END_OBJECT)) {
                indentation--;

                if (type == WJB_END_ARRAY && indentation == 1) {
                    // Store the part
                    parts.emplace_back(part);

                    // Reset
                    part = mamba::specs::VersionPart();
                    part.clear();
                }
            }

            std::string indent_str(indentation * 2, ' ');

            // elog(NOTICE, "%s%s", indent_str.c_str(), CONDA_PSQL_TYPES_STR[type]);

            if ((type == WJB_BEGIN_ARRAY) || (type == WJB_BEGIN_OBJECT)) {
                indentation++;
            }

            // if (type == WJB_BEGIN_ARRAY && indentation > 1) {
            //     processingAtom = true;
            // }

            if (type == WJB_KEY) {
                if (strncmp(val.val.string.val, (char*)CONDA_JSON_KEY_LITERAL, val.val.string.len) == 0)
                {
                    JsonbIteratorNext(&it, &val, true);
                    literal = std::string(val.val.string.val, val.val.string.len);
                    // elog(NOTICE, "%sUnpacked literal: '%s'", indent_str.c_str(), literal.c_str());
                }
                else if (strncmp(val.val.string.val, (char*)CONDA_JSON_KEY_NUMERAL, val.val.string.len) == 0)
                {
                    JsonbIteratorNext(&it, &val, true);
                    numeral = DatumGetInt64(DirectFunctionCall1(numeric_int8, NumericGetDatum(val.val.numeric)));
                    // elog(NOTICE, "%sUnpacked numeral: %ld", indent_str.c_str(), numeral);
                }
            }

            if (type == WJB_END_OBJECT) {
                // Store the atom
                part.emplace_back(mamba::specs::VersionPartAtom(numeral, literal));
            }
        }
        return parts;
    }

    mamba::specs::Version jsonb_to_cpp_version(Jsonb* jsonb) {
        // elog(NOTICE, "jsonb_to_cpp_version");

        // JsonbValue epoch_key_, version_key_, local_key_;
        // epoch_key_.type = jbvString;
        // epoch_key_.val.string.val = (char*)CONDA_JSON_KEY_EPOCH;
        // epoch_key_.val.string.len = std::strlen(CONDA_JSON_KEY_EPOCH);
        // version_key_.type = jbvString;
        // version_key_.val.string.val = (char*)CONDA_JSON_KEY_VERSION;
        // version_key_.val.string.len = std::strlen(CONDA_JSON_KEY_VERSION);
        // local_key_.type = jbvString;
        // local_key_.val.string.val = (char*)CONDA_JSON_KEY_LOCAL;
        // local_key_.val.string.len = std::strlen(CONDA_JSON_KEY_LOCAL);

        if (!JB_ROOT_IS_OBJECT(jsonb)) {
            ereport(ERROR,
                    (errcode(ERRCODE_INVALID_PARAMETER_VALUE),
                    errmsg("cannot call %s on a non-jsonb object", __func__)));
        }


        auto version_parts = process_conda_jsonb_attr(jsonb, CONDA_JSON_KEY_VERSION);
        auto local_parts = process_conda_jsonb_attr(jsonb, CONDA_JSON_KEY_LOCAL);
        mamba::specs::Version version(0, std::move(version_parts), std::move(local_parts));
        return version;
    }

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

        auto version = &tmp_version.value();

        // Convert the Version object into a Jsonb object. This allows
        // to more easily serialize the Version object into a JSON string.
        // And more importantly, Jsonb is very fast.
        Jsonb* result = cpp_version_to_jsonb(version, str);

        PG_RETURN_POINTER(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_out);

    Datum
    condaversion_out(PG_FUNCTION_ARGS)
    {
        // elog(NOTICE, "Inside condaversion_out");
        Jsonb *jsonb_version = PG_GETARG_JSONB_P(0);

        JsonbValue attr_value;

        // Get the original string from the Jsonb.
        // mamba::specs::Version::parse is destructive. The output
        // string (from the str method) will potentially differ from
        // the original string.
        getKeyJsonValueFromContainer(
            &jsonb_version->root,
            CONDA_JSON_KEY_ORIGINAL,
            strlen(CONDA_JSON_KEY_ORIGINAL),
            &attr_value
        );

        PG_RETURN_CSTRING(attr_value.val.string.val);
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
        Jsonb *left_json = PG_GETARG_JSONB_P(0);
        Jsonb *right_json = PG_GETARG_JSONB_P(1);
        int32 result;

        mamba::specs::Version left = jsonb_to_cpp_version(left_json);
        mamba::specs::Version right = jsonb_to_cpp_version(right_json);
        result = condaversioncmp(&left, &right);

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_INT32(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_eq);

    Datum
    condaversion_eq(PG_FUNCTION_ARGS)
    {
        Jsonb *left_json = PG_GETARG_JSONB_P(0);
        Jsonb *right_json = PG_GETARG_JSONB_P(1);
        int32 result;

        mamba::specs::Version left = jsonb_to_cpp_version(left_json);
        mamba::specs::Version right = jsonb_to_cpp_version(right_json);

        result = condaversioncmp(&left, &right) == 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    ////////

    PG_FUNCTION_INFO_V1(condaversion_ne);

    Datum
    condaversion_ne(PG_FUNCTION_ARGS)
    {
        Jsonb *left_json = PG_GETARG_JSONB_P(0);
        Jsonb *right_json = PG_GETARG_JSONB_P(1);
        int32 result;

        mamba::specs::Version left = jsonb_to_cpp_version(left_json);
        mamba::specs::Version right = jsonb_to_cpp_version(right_json);

        result = condaversioncmp(&left, &right) != 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_lt);

    Datum
    condaversion_lt(PG_FUNCTION_ARGS)
    {
        Jsonb *left_json = PG_GETARG_JSONB_P(0);
        Jsonb *right_json = PG_GETARG_JSONB_P(1);
        int32 result;

        mamba::specs::Version left = jsonb_to_cpp_version(left_json);
        mamba::specs::Version right = jsonb_to_cpp_version(right_json);

        result = condaversioncmp(&left, &right) < 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_le);

    Datum
    condaversion_le(PG_FUNCTION_ARGS)
    {
        Jsonb *left_json = PG_GETARG_JSONB_P(0);
        Jsonb *right_json = PG_GETARG_JSONB_P(1);
        int32 result;

        mamba::specs::Version left = jsonb_to_cpp_version(left_json);
        mamba::specs::Version right = jsonb_to_cpp_version(right_json);

        result = condaversioncmp(&left, &right) <= 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_gt);

    Datum
    condaversion_gt(PG_FUNCTION_ARGS)
    {
        Jsonb *left_json = PG_GETARG_JSONB_P(0);
        Jsonb *right_json = PG_GETARG_JSONB_P(1);
        int32 result;

        mamba::specs::Version left = jsonb_to_cpp_version(left_json);
        mamba::specs::Version right = jsonb_to_cpp_version(right_json);

        result = condaversioncmp(&left, &right) > 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

    PG_FUNCTION_INFO_V1(condaversion_ge);

    Datum
    condaversion_ge(PG_FUNCTION_ARGS)
    {
        Jsonb *left_json = PG_GETARG_JSONB_P(0);
        Jsonb *right_json = PG_GETARG_JSONB_P(1);
        int32 result;

        mamba::specs::Version left = jsonb_to_cpp_version(left_json);
        mamba::specs::Version right = jsonb_to_cpp_version(right_json);

        result = condaversioncmp(&left, &right) >= 0;

        // PG_FREE_IF_COPY(left, 0);
        // PG_FREE_IF_COPY(right, 1);

        PG_RETURN_BOOL(result);
    }

}
