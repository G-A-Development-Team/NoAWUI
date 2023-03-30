local function outprint(label, type, text)
    print("[NoAWUI - " .. label .. "]", "[" .. type:upper() .. "] - " .. text)
end

local function outpanorama(label, type, text)
    panorama.RunScript([[
        $.Msg("[NoAWUI - ]] .. label .. [[]", "      []] .. type:upper() .. [[" + "] - " + "]] .. text .. [[");
    ]]);
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