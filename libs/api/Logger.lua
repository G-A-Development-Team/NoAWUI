local function outprint(label, type, text)
    if options.ScriptLoaded then
        print("[NoAWUI - " .. label .. "][USER]", "[" .. type:upper() .. "] - " .. text)
    else
        print("[NoAWUI - " .. label .. "][SCRIPT]", "[" .. type:upper() .. "] - " .. text)
    end
end

local function outpanorama(label, type, text)
    if options.ScriptLoaded then
        panorama.RunScript([[
            $.Msg("[NoAWUI - ]] .. label .. [[][USER]", "      []] .. type:upper() .. [[" + "] - " + "]] .. text .. [[");
        ]]);
    else
        panorama.RunScript([[
            $.Msg("[NoAWUI - ]] .. label .. [[][SCRIPT]", "      []] .. type:upper() .. [[" + "] - " + "]] .. text .. [[");
        ]]);
    end
end

function LogInfo(type, text)
    if options.logger.info ~= nil and options.logger.info then
        outprint("INFO", type, text)

        if options.panorama ~= nil and options.panorama then
            outpanorama("INFO", type, text)
        end
    end
end

function LogError(type, text)
    outprint("ERROR", type, text)
    if options.panorama ~= nil and options.panorama then
        outpanorama("ERROR", type, text)
    end
end

function LogWarn(type, text)
    outprint("WARN", type, text)
    if options.panorama ~= nil and options.panorama then
        outpanorama("WARN", type, text)
    end
end

function LogFatal(type, text)
    outprint("FATAL", type, text)
    if options.panorama ~= nil and options.panorama then
        outpanorama("FATAL", type, text)
    end
end

function LogDebug(type, text)
    if options.logger.debug ~= nil and options.logger.debug then
        outprint("DEBUG", type, text)

        if options.panorama ~= nil and options.panorama then
            outpanorama("DEBUG", type, text)
        end
    end
end