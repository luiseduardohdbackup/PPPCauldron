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

    _p.tanthetah = 0
    _p.tanthetav = 0
    _p.EPSILON = 0.001;
    _p.DTOR = 0.01745329252;
    _p.camera = camera:new()
    _p.screen = screen:new()
    _p.origin = point3D:new()
    _p.basisa = point3D:new()
    _p.basisb = point3D:new()
    _p.basisc = point3D:new()
    
    _p.p1 = point2D:new()
    _p.p2 = point2D:new()

    _p.e1 = point3D:new()
    _p.e2 = point3D:new()
    _p.n1 = point3D:new()
    _p.n2 = point3D:new()
    
    return _p
end 

--[[ trans_Initialise
        lorum ipsum
        
        @return - true or false depending on if initialisation has been successful.
        ]]
function Projection:trans_Initialise(  )
    -- Is the camera position and view vector coincident ?
    if EqualVertex(self.camera.to, self.camera.from) then
               return false;
    end 
    
    -- Is there a legal camera up vector ? 
    if EqualVertex( self.camera.up, self.origin ) then
        return false;
    end

    self.basisb.x = self.camera.to.x - self.camera.from.x
    self.basisb.y = self.camera.to.y - self.camera.from.y
    self.basisb.z = self.camera.to.z - self.camera.from.z
    self.Normalise(basisb)

    self.basisa= CrossProduct( self.camera.up, self.basisb )
    Normalise( self.basisa )

    -- Are the up vector and view direction colinear 
    if EqualVertex( self.basisa, self.origin) then
        return false;
    end

    self.basisc = CrossProduct( self.basisb, self.basisa );

    -- Do we have legal camera apertures ? 
    if self.camera.angleh < self.EPSILON or self.camera.anglev < self.EPSILON then
        return false;
    end

    -- Calculate camera aperture statics, note: angles in degrees 
    self.tanthetah = math.tan( self.camera.angleh * self.DTOR / 2);
    self.tanthetav = math.tan( self.camera.anglev * self.DTOR / 2);

    -- Do we have a legal camera zoom ? */
    if self.camera.zoom < self.EPSILON then
        return  false;
    end

    -- Are the clipping planes legal ? 
    if self.camera.front < 0 or self.camera.back < 0 or self.camera.back <= self.camera.front then
        return  false
    end

    return true;
end

--[[ trans_Initialise
        lorum ipsum
        
        @return - true or false depending on if initialisation has been successful.
        ]]
    function Projection:Trans_World2Eye( w, e )
         -- Translate world so that the camera is at the origin 
         w.x = w.x - self.camera.from.x;
         w.y = w.y - self.camera.from.y;
         w.z = w.z - self.camera.from.z;

         -- Convert to eye coordinates using basis vectors */
         e.x = w.x * self.basisa.x + w.y * self.basisa.y + w.z * self.basisa.z;

         e.y = w.x * self.basisb.x + w.y * self.basisb.y + w.z * self.basisb.z;
         e.z = w.x * self.basisc.x + w.y * self.basisc.y + w.z * self.basisc.z;
     end

    --[[ trans_Initialise
        lorum ipsum
        
        @return - true or false depending on if initialisation has been successful.
        ]]
 function Projection:Trans_ClipEye( e1, e2)
         local mu;

         -- Is the vector totally in front of the front cutting plane ? */
         if ( e1.y <= self.camera.front and e2.y <= self.camera.front) then
             return  false;
         end

         -- Is the vector totally behind the back cutting plane ? */
         if ( e1.y >= self.camera.back and e2.y >= self.camera.back) then
             return  false;
         end

         -- Is the vector partly in front of the front cutting plane ? */
         if (( e1.y < self.camera.front and e2.y > self.camera.front) or ( e1.y > self.camera.front and e2.y < self.camera.front)) then
             mu = ( self.camera.front - e1.y ) / ( e2.y - e1.y );

             if ( e1.y < camera.front) then
                 e1.x = e1.x + mu * ( e2.x - e1.x );
                 e1.z = e1.z + mu * ( e2.z - e1.z );
                 e1.y = self.camera.front;
             else
                 e2.x = e1.x + mu * ( e2.x - e1.x );
                 e2.z = e1.z + mu * ( e2.z - e1.z );
                 e2.y = self.camera.front;
             end
         end

         -- Is the vector partly behind the back cutting plane ? */
         if (( e1.y < self.camera.back and e2.y > self.camera.back ) or ( e1.y > self.camera.back and e2.y < self.camera.back )) then
             mu = ( self.camera.back - e1.y ) / ( e2.y - e1.y );

             if ( e1.y < camera.back) then
                 e2.x = e1.x + mu * ( e2.x - e1.x );
                 e2.z = e1.z + mu * ( e2.z - e1.z );
                 e2.y = self.camera.back;
             else
                 e1.x = e1.x + mu * ( e2.x - e1.x );
                 e1.z = e1.z + mu * ( e2.z - e1.z );
                 e1.y = self.camera.back;
             end
         end

         return true;
     end


--[[ trans_Initialise
    lorum ipsum

    @return - true or false depending on if initialisation has been successful.
    ]]
function Projection:Trans_Eye2Norm( e,  n )
     local d;

     if ( self.camera.projection == 0 ) then
         d = self.camera.zoom / e.y
         n.x = d * e.x / self.tanthetah
         n.y = e.y 
         n.z = d * e.z / self.tanthetav
     else
         n.x = self.camera.zoom * e.x / self.tanthetah;
         n.y = e.y;
         n.z = self.camera.zoom * e.z / self.tanthetav;
     end
 end


--[[ trans_Initialise
    lorum ipsum

    @return - true or false depending on if initialisation has been successful.
    ]]
function Projection:Trans_ClipNorm(  n1, n2 )
     local mu;

     -- Is the line segment totally right of x = 1 ? */
     if ( n1.x >= 1 and n2.x >= 1) then
         return  false;
     end

     -- Is the line segment totally left of x = -1 ? 
     if ( n1.x <= -1 and n2.x <= -1) then
         return  false;
    end

     -- Does the vector cross x = 1 ? 
     if (( n1.x > 1 and n2.x < 1) or ( n1.x < 1 and n2.x > 1)) then
         mu = ( 1 - n1.x ) / ( n2.x - n1.x);

         if ( n1.x < 1) then
             n2.z = n1.z + mu * ( n2.z - n1.z );
             n2.x = 1;
         else
             n1.z = n1.z + mu * ( n2.z - n1.z );
             n1.x = 1;
         end
     end

     -- Does the vector cross x = -1 ? 
     if (( n1.x < -1 and n2.x > -1) or ( n1.x > -1 and n2.x < -1)) then
         mu = ( -1 - n1.x ) / ( n2.x - n1.x );

         if ( n1.x > -1) then
             n2.z = n1.z + mu * ( n2.z - n1.z );
             n2.x = -1;
         else
             n1.z = n1.z + mu * ( n2.z - n1.z );
             n1.x = -1;
         end
     end

     -- Is the line segment totally above z = 1 ? */
     if ( n1.z >= 1 and n2.z >= 1) then
         return  false;
     end

     -- Is the line segment totally below z = -1 ? */
     if ( n1.z <= -1 and n2.z <= -1) then
         return  false;
    end 

     -- Does the vector cross z = 1 ? */
     if (( n1.z > 1 and n2.z < 1) or ( n1.z < 1 and n2.z > 1 )) then
         mu = (1 - n1.z ) / ( n2.z - n1.z );
         
         if ( n1.z < 1) then
             n2.x = n1.x + mu * ( n2.x - n1.x );
             n2.z = 1;
         else
             n1.x = n1.x + mu * ( n2.x - n1.x );
             n1.z = 1;
         end
     end

     -- Does the vector cross z = -1 ? */
     if (( n1.z < -1 and n2.z > -1) or ( n1.z > -1 and n2.z < -1)) then
         mu = (-1 - n1.z ) / ( n2.z - n1.z );

         if ( n1.z > -1) then
             n2.x = n1.x + mu * ( n2.x - n1.x);
             n2.z = -1;
         else
             n1.x = n1.x + mu * ( n2.x - n1.x);
             n1.z = -1;
         end
     end

     return true;
 end 


 --[[ trans_Initialise
    lorum ipsum

    @return - true or false depending on if initialisation has been successful.
    ]]
function Projection:Trans_Norm2Screen( norm,  projected )
     --MessageBox.Show("the value of  are");
     projected.h = self.screen.center.h - ( self.screen.size.h * norm.x / 2 );
     projected.v = self.screen.center.v - ( self.screen.size.v * norm.z / 2 );
 end


 --public bool Trans_Point();
--[[ trans_Initialise
    lorum ipsum

    @return - true or false depending on if initialisation has been successful.
    ]]
function Projection:Trans_Line( w1,  w2 )
     self:Trans_World2Eye(w1, self.e1);
     self:Trans_World2Eye(w2, self.e2);

     if self:Trans_ClipEye(self.e1, self.e2) then
         self:Trans_Eye2Norm(self.e1, n1);
         self:Trans_Eye2Norm(self.e2, n2);

         if  self:Trans_ClipNorm( self.n1, self.n2 ) then
             self:Trans_Norm2Screen( self.n1, self.p1 );
             self:Trans_Norm2Screen( self.n2, self.p2 );
             return true;
         end
     end

     return true;
 end

--[[ trans_Initialise
    lorum ipsum

    @return - true or false depending on if initialisation has been successful.
    ]]
function Projection:Normalise( v )
     local length;

     length = math.sqrt (v.x * v.x + v.y * v.y + v.z * v.z)
     v.x = v.x / length
     v.y = v.y / length
     v.z = v.z / length
 end

--[[ trans_Initialise
    lorum ipsum

    @return - true or false depending on if initialisation has been successful.
    ]]
function Projection:CrossProduct( p1, p2)
     local p3;
     p3 = point3D:new(0,0,0);

     p3.x = p1.y * p2.z - p1.z * p2.y;
     p3.y = p1.z * p2.x - p1.x * p2.z;
     p3.z = p1.x * p2.y - p1.y * p2.x;

     return p3;
 end

--[[ trans_Initialise
    lorum ipsum

    @return - true or false depending on if initialisation has been successful.
    ]]
function Projection:EqualVertex( p1,  p2 )
    if ( math.abs( p1.x - p2.x ) > EPSILON ) then
        return false
    end

    if ( math.abs( p1.y - p2.y) > EPSILON ) then
        return false;
    end

    if ( math.abs( p1.z - p2.z) > EPSILON ) then
        return false;
    end

    return(true);
end

return Projection