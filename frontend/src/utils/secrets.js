const SEP = ';';

export function humanReadableType(type) {
    switch(type) {
        case "SystemSettings::StringSetting":
            return "String";
        case "SystemSettings::StringListSetting":
            return "List of strings";
        case "SystemSettings::IntegerSetting":
            return "Integer";
        case "SystemSettings::IntegerListSetting":
            return "List of integers";
        default:
            return "Unknown";
    }
}

export function formatValue(type, value) {
    switch(type) {
        case "SystemSettings::StringListSetting":
        case "SystemSettings::IntegerListSetting":
            return value ? value.join(SEP) : value;
        default:
            return value;
    }
}