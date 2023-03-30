function LogInfo(type, text)
    if options.logger.info ~= nil and options.logger.info then
        print("[NoAWUI - INFO]", "[" .. type:upper() .. "] - " .. text)

        if options.panorama ~= nil and options.panorama then
            panorama.RunScript([[
                $.Msg("[NoAWUI - INFO]", "      []] .. type:upper() .. [[" + "] - " + "]] .. text .. [[");
            ]]);
        end
    end
end