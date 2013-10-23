module(..., package.seeall )

local screen = require("Projection.Screen")
local camera = require("Projection.Camera")
local point2D = require("Projection.Point2D")
local point3D = require("Projection.Point3D")

local Projection = {}


--[[
    Class description
]]
function Projection:new( _p, argTable )
    _p = _p or {}
    setmetatable( _p, self )
    
    self.__index = self

            _p.EPSILON = 0.001;
            _p.DTOR = 0.01745329252;
            _p.camera = camera.new()
            _p.screen = screen.new()
            _p.origin = point3D.new()
            _p.basisa = point3D.new()
            _p.basisb = point3D.new()
            _p.basisc = point3D.new()
            _p.p1 = point2D.new()
            _p.p2 = point2D.new()
            
            _p.e1 = point3D.new()
            _p.e2 = point3D.new()
            _p.n1 = point3D.new()
            _p.n2 = point3D.new()
    return _p
end 

--[[ trans_Initialise
        lorum ipsum
        
        @return - true or false depending on if initialisation has been successful.
        ]]
function Projection:trans_Initialise(  )
    -- Is the camera position and view vector coincident ?
    if EqualVertex(camera.to, camera.from) then
               return (false);
    end 
    
    -- Is there a legal camera up vector ? 
    if EqualVertex(camera.up, origin) then
        return (false);
    end

    basisb.x = camera.to.x - camera.from.x
    basisb.y = camera.to.y - camera.from.y
    basisb.z = camera.to.z - camera.from.z
    Normalise(basisb)

    basisa= CrossProduct(camera.up, basisb)
    Normalise(basisa)

    -- Are the up vector and view direction colinear 
    if (EqualVertex(basisa, origin) then
        return (false);
    end

    basisc=CrossProduct(basisb, basisa);

    -- Do we have legal camera apertures ? 
    if camera.angleh < EPSILON or camera.anglev < EPSILON then
        return (false);
    end

    -- Calculate camera aperture statics, note: angles in degrees 
    tanthetah = math.tan(camera.angleh * DTOR / 2);
    tanthetav = math.tan(camera.anglev * DTOR / 2);

    -- Do we have a legal camera zoom ? */
    if camera.zoom < EPSILON then
        return (false);
    end

    -- Are the clipping planes legal ? 
    if camera.front < 0 or camera.back < 0 or camera.back <= camera.front then
        return (false)
    end

    return true;
end

-- Return the created class template
return Projection

 
 
       function Trans_World2Eye( w, e )
            -- Translate world so that the camera is at the origin 
            w.x -= camera.from.x;
            w.y -= camera.from.y;
            w.z -= camera.from.z;
 
            -- Convert to eye coordinates using basis vectors */
            e.x = w.x * basisa.x + w.y * basisa.y + w.z * basisa.z;
 
            e.y = w.x * basisb.x + w.y * basisb.y + w.z * basisb.z;
            e.z = w.x * basisc.x + w.y * basisc.y + w.z * basisc.z;
        end
 
        function Trans_ClipEye( e1, e2)
            local mu;
 
            -- Is the vector totally in front of the front cutting plane ? */
            if (e1.y <= camera.front and e2.y <= camera.front) then
                return (false);
            end
 
            -- Is the vector totally behind the back cutting plane ? */
            if (e1.y >= camera.back and e2.y >= camera.back) then
                return (false);
            end
 
            -- Is the vector partly in front of the front cutting plane ? */
            if ((e1.y < camera.front and e2.y > camera.front) or (e1.y > camera.front and e2.y < camera.front)) then
                mu = (camera.front - e1.y) / (e2.y - e1.y);
                
                if (e1.y < camera.front) then
                    e1.x = e1.x + mu * (e2.x - e1.x);
                    e1.z = e1.z + mu * (e2.z - e1.z);
                    e1.y = camera.front;
                else
                    e2.x = e1.x + mu * (e2.x - e1.x);
                    e2.z = e1.z + mu * (e2.z - e1.z);
                    e2.y = camera.front;
                end
            end
            
            -- Is the vector partly behind the back cutting plane ? */
            if ((e1.y < camera.back and e2.y > camera.back) or (e1.y > camera.back and e2.y < camera.back)) then
                mu = (camera.back - e1.y) / (e2.y - e1.y);
                
                if (e1.y < camera.back) then
                    e2.x = e1.x + mu * (e2.x - e1.x);
                    e2.z = e1.z + mu * (e2.z - e1.z);
                    e2.y = camera.back;
                else
                {
                    e1.x = e1.x + mu * (e2.x - e1.x);
                    e1.z = e1.z + mu * (e2.z - e1.z);
                    e1.y = camera.back;
                end
            end
 
            return (true);
        end
        
        
        function Trans_Eye2Norm(_3Dpoint e, _3Dpoint n)
            double d;
 
            if (camera.projection == 0) then
                d = camera.zoom / e.y;
                n.x = d * e.x / tanthetah;
                n.y = e.y; 
                n.z = d * e.z / tanthetav;
            else
                n.x = camera.zoom * e.x / tanthetah;
                n.y = e.y;
                n.z = camera.zoom * e.z / tanthetav;
            end
        end
        
        
        function Trans_ClipNorm(_3Dpoint n1, _3Dpoint n2)
            double mu;
 
            -- Is the line segment totally right of x = 1 ? */
            if (n1.x >= 1 and n2.x >= 1) then
                return (false);
            end
            
 
            -- Is the line segment totally left of x = -1 ? 
            if (n1.x <= -1 and n2.x <= -1) then
                return (false);
           end
 
            -- Does the vector cross x = 1 ? 
            if ((n1.x > 1 and n2.x < 1) or (n1.x < 1 and n2.x > 1)) then
                mu = (1 - n1.x) / (n2.x - n1.x);
                
                if (n1.x < 1) then
                    n2.z = n1.z + mu * (n2.z - n1.z);
                    n2.x = 1;
                else
                    n1.z = n1.z + mu * (n2.z - n1.z);
                    n1.x = 1;
                end
            end
 
            -- Does the vector cross x = -1 ? 
            if ((n1.x < -1 and n2.x > -1) or (n1.x > -1 and n2.x < -1)) then
                mu = (-1 - n1.x) / (n2.x - n1.x);
                
                if (n1.x > -1) then
                    n2.z = n1.z + mu * (n2.z - n1.z);
                    n2.x = -1;
                else
                    n1.z = n1.z + mu * (n2.z - n1.z);
                    n1.x = -1;
                end
            end
 
            -- Is the line segment totally above z = 1 ? */
            if (n1.z >= 1 and n2.z >= 1) then
                return (false);
            end
 
            -- Is the line segment totally below z = -1 ? */
            if (n1.z <= -1 and n2.z <= -1) then
                return (false);
           end 
           
            -- Does the vector cross z = 1 ? */
            if ((n1.z > 1 and n2.z < 1) or (n1.z < 1 and n2.z > 1)) then
                mu = (1 - n1.z) / (n2.z - n1.z);
                \
                if (n1.z < 1) then
                    n2.x = n1.x + mu * (n2.x - n1.x);
                    n2.z = 1;
                else
                    n1.x = n1.x + mu * (n2.x - n1.x);
                    n1.z = 1;
                end
            end
 
            -- Does the vector cross z = -1 ? */
            if ((n1.z < -1 and n2.z > -1) or (n1.z > -1 and n2.z < -1)) then
                mu = (-1 - n1.z) / (n2.z - n1.z);
                
                if (n1.z > -1) then
                    n2.x = n1.x + mu * (n2.x - n1.x);
                    n2.z = -1;
                else
                    n1.x = n1.x + mu * (n2.x - n1.x);
                    n1.z = -1;
                end
            end
 
            return (true);
        end 
        
        
        function Trans_Norm2Screen(_3Dpoint norm, _2Dpoint projected)
            --MessageBox.Show("the value of  are");
            projected.h = Convert.ToInt32(screen.center.h - screen.size.h * norm.x / 2);
            projected.v = Convert.ToInt32(screen.center.v - screen.size.v * norm.z / 2);
        end
        
        
        --public bool Trans_Point();
       function Trans_Line(_3Dpoint w1, _3Dpoint w2)
            Trans_World2Eye(w1, e1);
            Trans_World2Eye(w2, e2);
            
            if (Trans_ClipEye(e1, e2)) then
                Trans_Eye2Norm(e1, n1);
                Trans_Eye2Norm(e2, n2);
                
                if (Trans_ClipNorm(n1, n2)) then
                    Trans_Norm2Screen(n1, p1);
                    Trans_Norm2Screen(n2, p2);
                    return (true);
                end
            end
           
            return (true);
        end
        
        function Normalise(_3Dpoint v)
            double length;
 
            length = Math.Sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
            v.x /= length;
            v.y /= length;
            v.z /= length;
        end
        
       function CrossProduct(_3Dpoint p1,_3Dpoint p2)
            _3Dpoint p3;
            p3 = new _3Dpoint(0,0,0);
            p3.x = p1.y * p2.z - p1.z * p2.y;
            p3.y = p1.z * p2.x - p1.x * p2.z;
            p3.z = p1.x * p2.y - p1.y * p2.x;
            return p3;
        end
        
        function EqualVertex(_3Dpoint p1, _3Dpoint p2)
             if (Math.Abs(p1.x - p2.x) > EPSILON)
             return(false);
             if (Math.Abs(p1.y - p2.y) > EPSILON)
             return(false);
             if (Math.Abs(p1.z - p2.z) > EPSILON)
             return(false);
 
             return(true);
        end
            
