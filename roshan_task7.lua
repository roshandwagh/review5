api = freeswitch.API()

local check = freeswitch.Dbh("freeswitch","aaqib","A@qib_1997")

if (check:connected()) then

  session:consoleLog("info",   "We are CONNECTED to the Freeswitch Database\n");

else
    session:consoleLog("err",   "NOT CONNECTED TO FREESWITCH DATABASE\n");

end
