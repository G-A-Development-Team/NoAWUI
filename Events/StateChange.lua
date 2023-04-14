local Event_Name = "statechange"
local Event_Function = "Event_StateChange"

function Event_StateChange(self, settings)
    if self.Events[Event_Function] == nil then
        self.Events[Event_Function] = {
            State = settings.State,
        }
    end
    
    if isMouseInRect(self.X + settings.Parent.X, self.Y + settings.Parent.Y, self.Width, self.Height) then
        if input.IsButtonReleased(1) then 
            if self.StateChange ~= nil then
                ExecuteLuaString(self.StateChange)
            end
            self.Events[Event_Function].State = not self.Events[Event_Function].State
        end
    end
    return self.Events[Event_Function].State
end

Events_Details[Event_Name] = {}
Events_Details[Event_Name]['parms'] = 2
Events_Details[Event_Name]['function'] = Event_Function
table.insert(Events_Objects, Event_Name)