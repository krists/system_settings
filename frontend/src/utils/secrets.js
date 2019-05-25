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
        case "SystemSettings::BooleanSetting":
            return "Boolean";
        default:
            return "Unknown";
    }
}

export function formatValueForForm(type, value) {
    switch(type) {
        case "SystemSettings::StringListSetting":
            return value.map((str) => {
                if(str && str.replace){
                    return str.replace(SEP, `\\${SEP}`);
                } else {
                    return "";
                }
            }).join(SEP);
        case "SystemSettings::IntegerListSetting":
            return value ? value.join(SEP) : value;
        case "SystemSettings::BooleanSetting":
            return value;
        default:
            return value;
    }
}