local Animation_Name = "fadein"
local Animation_Function = "Animation_FadeIn"

function Animation_FadeIn(self, settings)

    if self.Animations[Animation_Name] == nil then
        self.Animations[Animation_Name] = {
            Animate = false,
            Background = settings.Reference
        }
    end
    
    if settings.Ignore == nil then
        if tonumber(self.Animations[Animation_Name].Background[4]) ==  tonumber(settings.MaxOpacity) or tonumber(self.Animations[Animation_Name].Background[4]) > tonumber(settings.MaxOpacity) then
            return true
        end 
    end

    if not self.Visible then self.Animations[Animation_Name].Animate = false return self end

    if self.Animations[Animation_Name].Animate == false then
        self.Animations[Animation_Name].Background[4] = 0
        self.Animations[Animation_Name].Animate = true
    end
    if self.Animations[Animation_Name].Animate and self.Animations[Animation_Name].Background[4] < settings.MaxOpacity then
        if self.Animations[Animation_Name].Background[4] + settings.IncrementOpacity <= settings.MaxOpacity then
            self.Animations[Animation_Name].Background[4] = self.Animations[Animation_Name].Background[4] + settings.IncrementOpacity
        else
            self.Animations[Animation_Name].Background[4] = settings.MaxOpacity
        end
    end
    
    return false
end

Animations_Details[Animation_Name] = {}
Animations_Details[Animation_Name]['parms'] = 2
Animations_Details[Animation_Name]['function'] = Animation_Function
table.insert(Animations_Objects, Animation_Name)