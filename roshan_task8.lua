local function playWelcome()
      session:execute("playback","/home/aaqib/Downloads/roshan_welcome.mp3")
end

local function play_unauth()
      local digit
             digit=session:playAndGetDigits(1,1,1,5000,"#","/home/aaqib/Downloads/roshan_unauth.wav","","[12]")
            return digit

end

local function play_goodbye()
       session:execute("playback","/home/aaqib/Downloads/roshan_unauth_no.mp3")
end
local function play_lang()
local digit
             digit=session:playAndGetDigits(1,1,1,5000,"#","/home/aaqib/Downloads/roshan_lang.mp3","","[01239]")
            return digit

end

api = freeswitch.API()

local dbh = freeswitch.Dbh("freeswitch", "aaqib", "A@qib_1997")

assert(dbh:connected())

dbh:test_reactive("SELECT * FROM Roshan", "DROP TABLE Roshan", "CREATE TABLE Roshan (EMPID int primary key AUTO_INCREMENT, Number varchar(150) DEFAULT NULL, CALL_UUID varchar(100) DEFAULT NULL, FROM_NUMBER varchar(100) DEFAULT NULL, TO_NUMBER varchar(100) DEFAULT NULL, REMOTE_IP varchar(150) DEFAULT NULL)")


local caller_id_number=tostring(session:getVariable("caller_id_number"))
local uuid=session:getVariable("uuid")
local tonum=session:getVariable("destination_number")
local remoteIP=tostring(session:getVariable("network_addr"))

dbh:query("SELECT * FROM Roshan WHERE FROM_NUMBER="..caller_id_number, function(row)
num=string.format("%s",row.FROM_NUMBER)
end )

if ( num == NULL )then

       if (play_unauth()=="1") then
              dbh:query("INSERT INTO Roshan (CALL_UUID,FROM_NUMBER,TO_NUMBER,REMOTE_IP) VALUES (".."\""..uuid.."\""..",".."\""..caller_id_number.."\""..",".."\""..tonum.."\""..",".."\""..remoteIP.."\""..")")
              
        else
                play_goodbye()
        end
else 

repeat
      playWelcome()
repeat
lang=play_lang() 
       
until lang~="0"

until lang~="9"
end           

repeat

 digit= session:playAndGetDigits(5,10,1,10000,"#","/home/aaqib/Downloads/roshan_enter_mobile.mp3","/home/aaqib/Downloads/roshan_unauth_no.mp3","\\d+")

until #digit>=10

dbh:query("UPDATE Roshan SET Number="..digit.." WHERE FROM_NUMBER="..caller_id_number)

local var
if lang=="1" then
 
      var= session:playAndGetDigits(1,1,3,5000,"#","/home/aaqib/Downloads/roshan_hinMenu.mp3","","[123]")
elseif lang=="2" then

      var=session:playAndGetDigits(1,1,3,5000,"#","/home/aaqib/Downloads/roshan_enMenu.mp3","","[123]")

elseif lang=="3" then
       var=session:playAndGetDigits(1,1,3,5000,"#","/home/aaqib/Downloads/roshan_gujMenu.mp3","","[123]")

end

if var=="1" then
  session:execute("bridge","user/9812678@"..remoteIP)
elseif var=="2" then
  session:execute("voicemail","default $${domain} 1002")
elseif var=="3" then
session:execute("playback","/home/aaqib/Downloads/roshan_welcome.mp3")
session:execute("conference","bridge:"..uuid..":user/9812678@$${domain}")

end





