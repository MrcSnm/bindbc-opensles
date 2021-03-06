module opensles_utils;
// import bindbc.OpenSLES.sles;
import bindbc.OpenSLES.types;

/**
*   Returns a comprehensive error message
*/
string slResultToString(SLresult res)
{
    switch (res)
    {
        case SL_RESULT_SUCCESS: return "Success";
        case SL_RESULT_BUFFER_INSUFFICIENT: return "Buffer insufficient";
        case SL_RESULT_CONTENT_CORRUPTED: return "Content corrupted";
        case SL_RESULT_CONTENT_NOT_FOUND: return "Content not found";
        case SL_RESULT_CONTENT_UNSUPPORTED: return "Content unsupported";
        case SL_RESULT_CONTROL_LOST: return "Control lost";
        case SL_RESULT_FEATURE_UNSUPPORTED: return "Feature unsupported";
        case SL_RESULT_INTERNAL_ERROR: return "Internal error";
        case SL_RESULT_IO_ERROR: return "IO error";
        case SL_RESULT_MEMORY_FAILURE: return "Memory failure";
        case SL_RESULT_OPERATION_ABORTED: return "Operation aborted";
        case SL_RESULT_PARAMETER_INVALID: return "Parameter invalid";
        case SL_RESULT_PERMISSION_DENIED: return "Permission denied";
        case SL_RESULT_PRECONDITIONS_VIOLATED: return "Preconditions violated";
        case SL_RESULT_RESOURCE_ERROR: return "Resource error";
        case SL_RESULT_RESOURCE_LOST: return "Resource lost";
        case SL_RESULT_UNKNOWN_ERROR: return "Unknown error";
        default: return "Undefined error";
    }
}