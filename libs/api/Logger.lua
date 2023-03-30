function LogInfo(type, text)
    if options.logger.info ~= nil and options.logger.info then
        print("[NoAWUI - INFO]", "[" .. type:upper() .. "] - " .. text) 
    end
end