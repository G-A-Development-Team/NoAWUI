local CurTime = function() 
    return globals.CurTime()
end


timer = timer or {}
timers = timers or {}


function timer.Create(name, delay, repetitions, func)
    timers[name] = {
        type = "Create",
        delay = delay, 
        func = func, 
        lastTime = CurTime() + delay,
        repetitions = repetitions,
        init_repetitions = repetitions,
        start_time = CurTime()
    }
end


function timer.Simple(name, delay, func)
    timers[name] = {
        type = "Simple", 
        func = func, 
        lastTime = CurTime() + delay, 
        delay = delay,
        start_time = CurTime(),
    }
end


function timer.Spam(name, duration, func)
    timers[name] = {
        type = "Spam", 
        duration = duration, 
        func = func, 
        lastTime = CurTime(),
        start_time = CurTime(),
    }
end



function timer.Exists(name)
    return timers[name]
    -- return timers["__TimerExistsCheck__" .. name]
end

function timer.Remove(name)
    timers[name] = nil
end

function timer.Pause(name)
    timers[name].pause = true
    return timers[name]
end


function timer.UnPause(name)
    timers[name].pause = false
    return timers[name]
end

function timer.Toggle(name)
    timers[name].pause = not timers[name].pause
    return timers[name]
end


function timer.RepsLeft(name)
    return timers[name].type == "Create" and timers[name].repetitions or 1
end


-- Return the time when the timer will be deleted. 
function timer.EndTime(name)
    return timers[name].type == "Create" and timer.RepsLeft(name) * timers[name].delay + CurTime() or CurTime() + timers[name].duration
end

function timer.TimeLeft(name)
    return timers[name].type == "Create" and timer.EndTime(name) - CurTime() or timers[name].duration - CurTime() + timers[name].start_time
end


function timer.Restart(name)
    timers[name].repetitions = timers[name].init_repetitions
    return timers[name]
end


function timer.Adjust(name, tbl)
    -- tbl is meant to be used as default parameters, like in python.
    -- https://stackoverflow.com/questions/6022519/define-default-values-for-function-arguments

    -- Optional tbl parameters
    -- Create - {delay = delay, repetitions = repetitions, func = func}
    -- Simple - {func = func, delay = delay}
    -- Spam - {duration = duration, func = func}

    if timers[name].type == "Create" then
        timers[name].delay = tbl.delay or timers[name].delay
        timers[name].repetitions = tbl.repetitions or timers[name].repetitions
        timers[name].func = tbl.func or timers[name].func
    elseif timers[name].type == "Simple" then
        timers[name].delay = tbl.delay or timers[name].delay
        timers[name].func = tbl.func or timers[name].func
    elseif timers[name].type == "Spam" then
        timers[name].duration = tbl.duration or timers[name].duration
        timers[name].func = tbl.func or timers[name].func
    end
end


function timer.Call(name, ...)
    return timers[name].func(...)
end

function timer.GetFunction(name)
    return timers[name].func
end


function timer.Tick()
    for timer_name, timer_data in pairs(timers) do
        if not timer_data.pause then
            -- timer.Create
            if timer_data.type == "Create" then
                if timer_data.repetitions <= 0 and timer_data.init_repetitions ~= 0 then -- if the init_repetitions is 0, then it will never stop.
                    timer.Remove(timer_name)
                end
                if CurTime() >= timer_data.lastTime then
                    timer_data.lastTime = CurTime() + timer_data.delay
                    timer_data.func()
                    timer_data.repetitions = timer_data.repetitions - 1
                end
            -- timer.Simple
            elseif timer_data.type == "Simple" then
                if CurTime() >= timer_data.lastTime then
                    timer_data.func()
                    timer.Remove(timer_name)
                end
            -- timer.Spam
            elseif timer_data.type == "Spam" then
                timer_data.func()
                if CurTime() >= timer_data.lastTime + timer_data.duration then
                    timer.Remove(timer_name)
                end
            end
        end
    end
	
end


callbacks.Register("Draw", timer.Tick)