local Animation_Name = "fadein"
local Animation_Function = "Animation_FadeIn"

function Animation_FadeIn(self)
    if not self.Visible then self.Animation = false return self end

    if self.Animation == false then
        self.Background[4] = 0
        self.Animation = true
    end
    if self.Animation and self.Background[4] < 255 then
        if self.Background[4] + 17 <= 255 then
            self.Background[4] = self.Background[4] + 17
        else
            self.Background[4] = 255
        end
    end
    return self
end

Animations_Details[Animation_Name] = {}
Animations_Details[Animation_Name]['parms'] = 2
Animations_Details[Animation_Name]['function'] = Animation_Function
table.insert(Animations_Objects, Animation_Name)