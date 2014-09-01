__luaVersion=20140718000
--[[----------- NOTE: read me first if you want to modify it---------------
1\
the first line of this lua file _MUST_ be __luaVersion !!
we use this __luaVersion both in java(getLatestDBFile) & this lua script
NOTE: __luaVersion=XXXXX !! there is NO space between (__luaVersion & =) nether (= & XXXXX)
any question feel free to ask me:chenee@hhcn.com or chenee543216@gmail.com

2\
 version: 20140718000 is the release version !
 DO _NOT_ change function any more! (just add a new one)
 any additional change should apply with version compare.
 (
 if __luaVersion > 2014xxxxxx then
      call NewFunction()
 else if __luaVersion == 2014xxxxYYYY then
      call SomeFunction()
 else
      call OldFunction()
 end
 )
 and consider carefully about deprecate situations
]]
__forceUpdate = false
---------------------------------------------------
--
-- Docs
--
--------------------------------------------------
CaloriesDoc1={
{str="≈1个茶叶蛋",	calories=96},
{str="≈1片面包",	calories=100},
{str="≈1瓶冰红茶",	calories=112},
{str="≈1个煎蛋",	calories=118},
{str="≈2串羊肉串",	calories=124},
{str="≈1罐可乐",	calories=153},
{str="≈3串羊肉串",	calories=186},
{str="≈2个茶叶蛋",	calories=192},
{str="≈2片面包",	calories=200},
{str="≈1碗米饭",	calories=210},
{str="≈1个馒头",	calories=221},
{str="≈1根冰糖葫芦",	calories=223},
{str="≈2瓶冰红茶",	calories=224},
{str="≈1包小薯条",	calories=224},
{str="≈1个蛋黄派",	calories=224},
{str="≈2个煎蛋",	calories=236},
{str="≈4串羊肉串",	calories=248},
{str="≈1个汉堡",	calories=260},
{str="≈1根油条",	calories=270},
{str="≈1个肉包子",	calories=272},
{str="≈3个茶叶蛋",	calories=288},
{str="≈1个甜筒",	calories=290},
{str="≈3片面包",	calories=300},
{str="≈2罐可乐",	calories=306},
{str="≈1包中薯条",	calories=328},
{str="≈3个煎蛋",	calories=354},
{str="≈1个蛋挞",	calories=393},
{str="≈4片面包",	calories=400},
{str="≈1包大薯条",	calories=402},
{str="≈2碗米饭",	calories=420},
{str="≈2个馒头",	calories=442},
{str="≈2根冰糖葫芦",	calories=446},
{str="≈1个蛋黄派",	calories=448},
{str="≈1包方便面",	calories=470},
{str="≈5片面包",	calories=500},
{str="≈1盘蛋炒饭",	calories=516},
{str="≈2个汉堡",	calories=520},
{str="≈2根油条",	calories=540},
{str="≈2个肉包子",	calories=544},
{str="≈2个甜筒",	calories=580},
{str="≈1碗方便面",	calories=581},
{str="≈1碗牛肉拉面",	calories=593},
{str="≈10串羊肉串",	calories=620},
{str="≈3碗米饭",	calories=630},
{str="≈3个馒头",	calories=663},
{str="≈2个蛋挞",	calories=786},
{str="≈3根油条",	calories=810},
{str="≈3个肉包子",	calories=816},
}


MODE_STEP = 0x01;
MODE_SLEEP = 0x10;
NEW_RECORD_MIN = 4000;

function getCaloriesString(calories)
    defautMsg  = ""
    threshHoldValue = 96

    if calories < threshHoldValue then
        return defautMsg
    end

    min = calories - 10
    if min < threshHoldValue then
        min  = threshHoldValue
    end
    max = calories + 10

    t = {}
    for i,item in ipairs(CaloriesDoc1) do
        _s = item["str"]
        _c = item["calories"]

        if _c >= min and _c <= max then
            table.insert(t,_s)
        end
    end


    if #t > 0 then
        r = math.random(1,#t)
        r2 = math.random(1,#t2)
        return t[r]
    end

    mod = calories % 9
    fat = (calories - mod) / 9
    msg = ", 轻松甩掉".. fat .."克肥肉"
    return msg
end

---------------------------------------------------
--
-- helpers
--
--------------------------------------------------
__log = nil
function log(msg, right)
    if __log == nil then __log = luajava.bindClass("android.util.Log") end

    if right == 'w' then
        __log:w("chenee",'luaScript('..__luaVersion.."):" ..msg)
    elseif right == 'e' then
        __log:e("chenee",'luaScript('..__luaVersion.."):" ..msg)
    else
        __log:d("chenee",'luaScript('..__luaVersion.."):" ..msg)
    end
end

-----------------------------------------------------------
--
--CAUTION: this function will del whole msg DB
--
-----------------------------------------------------------
function clearDB(ConfigInfo)
    luaAction = ConfigInfo:getLuaAction()
    if( luaAction ~= nil) then
        log("xxxxxxxxxxxxxxxxxx clearDB xxxxxxxxxxxxx")
        luaAction:clearDB()
    end
end

function clearDBOnceADay(ConfigInfo)

    luaAction = ConfigInfo:getLuaAction()
    listDao = luaAction:getDao()
    qb = listDao:queryBuilder()

    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")

    today = "" .. os.date("%Y-%m-%d",os.time())
    w1 = Properties.Date:eq(today)
    w2 = Properties.Type:eq("9999") -- 9999 is controll msg

    luaAction:queryWhere(qb,w1)
    luaAction:queryWhere(qb,w2)

    n = luaAction:queryCount(qb)
    if n > 0 then
        return
    end


    clearDB(ConfigInfo)

    t = {}
    t.t1 = ""..__luaVersion
    t.t2 = ""..__javaVersion
    t.stype = "9999"
    setMessage(listDao,t)
end

function clearDBOnceAVersion(ConfigInfo)

    luaAction = ConfigInfo:getLuaAction()
    listDao = luaAction:getDao()
    qb = listDao:queryBuilder()

    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")

    w1 = Properties.Text1:eq(""..__luaVersion)
    w2 = Properties.Type:eq("9999") -- 9999 is controll msg

    luaAction:queryWhere(qb,w1)
    luaAction:queryWhere(qb,w2)

    n = luaAction:queryCount(qb)
    if n > 0 then
        return
    end


    clearDB(ConfigInfo)

    t = {}
    t.t1 = ""..__luaVersion
    t.t2 = ""..__javaVersion
    t.stype = "9999"
    setMessage(listDao,t)
end

__javaVersion = 0
function setVersion(ConfigInfo,v)
    __javaVersion = v
    log("java version is: "..__javaVersion)

    --for later use
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

--    clearDB(ConfigInfo)
--    clearDBOnceADay(ConfigInfo)
--    clearDBOnceAVersion(ConfigInfo)
end

function compareVersion(v)
    if __javaVersion == 0 then
        log("not set java version yet!","e")
        return false
    end

    if v >= __javaVersion then
        return true
    else
        return false
    end
end

--
--judge whether this msg already exist or not
--
function judgeUniqueByDate_Type(listDao,ConfigInfo,stype)
    luaAction = ConfigInfo:getLuaAction()
    qb = listDao:queryBuilder()

    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")

    today = "" .. os.date("%Y-%m-%d",os.time())
    w1 = Properties.Date:eq(today)
    w2 = Properties.Type:eq(stype)

    luaAction:queryWhere(qb,w1)
    luaAction:queryWhere(qb,w2)

    n = luaAction:queryCount(qb)
    if n >= 1 then
        log("already add msg, type is: "..stype,"e")
        return false
    else
        return true
    end
end

function getTimeString1(time)
    m1 = time % 60
    h1 = (time - m1) / 60

    if(h1 < 1) then
        return m1 .."verbale"
    else
        return h1 .. "ora" .. m1 .. "verbale"
    end
end

function getTimeString2(start, stop)
    m1 = start % 60
    h1 = (start - m1) / 60

    sm1=nil
    if m1 < 10 then
        sm1 = "0"..m1
    else
        sm1 = ""..m1
    end

    m2 = stop % 60
    h2 = (stop - m2) /60

    sm2=nil
    if m2 < 10 then
        sm2 = "0"..m2
    else
        sm2 = ""..m2
    end

    return (""..h1..":"..sm1.."-"..h2..":"..sm2)
end

---------------------------------------------------
--
-- funcs
--
--------------------------------------------------

--
--generate msg & insert into DB
--
function setMessage(listDao,table)
    log('setMsg: '..table.t1)
    log('setMsg: '..table.t1.." / "..table.t2,'d')

    listItem = table.listItem
    if listItem == nil then
        listItem = luajava.newInstance("de.greenrobot.daobracelet.LuaList")
    end

    -- 1 auto set date/time/__luaVersion
    time = os.date("%X",os.time())
    time = string.sub(time,0,5)
    listItem:setTime(""..time)

    date = "" .. os.date("%Y-%m-%d",os.time())
    listItem:setDate(date)

    listItem:setScriptVersion(""..__luaVersion)

    -- 2 set item according to table
    t = table
    if t.t1 ~= nil then
        listItem:setText1(t.t1)
    end

    if t.t2 ~= nil then
        listItem:setText2(t.t2)
    end

    if t.json ~= nil then
        listItem:setJsonString(t.json)
    end

    if t.stype ~= nil then
        listItem:setType(t.stype)
    end

    if t.strScript ~= nil then
        listItem:setLuaActionScript(t.strScript)
    else
        listItem:setLuaActionScript("")
    end

    if t.start ~= nil then
        listItem:setStart(t.start)
    end

    if t.stop ~= nil then
        listItem:setStop(t.stop)
    end

    if t.index ~= nil then
        listItem:setIndex(t.index)
    end

    if t.right ~= nil then
        listItem:setRight(t.right)
    end


    listDao:insertOrReplace(listItem)
end

--
-- if exist return
--
function uniqueMsg(listDao,ConfigInfo,table)
    if false == judgeUniqueByDate_Type(listDao,ConfigInfo,table.stype) then
        return
    end

    setMessage(listDao,table)
end

--
-- if exist(date,type) del it & insert new
--
function replaceMsgByType(listDao,ConfigInfo,table)
    --del old msg
    qb = listDao:queryBuilder()
    luaAction = ConfigInfo:getLuaAction()
    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")

    today = "" .. os.date("%Y-%m-%d",os.time())
    w1 = Properties.Date:eq(today)
    w2 = Properties.Type:eq(table.stype)


    luaAction:queryWhere(qb,w1)
    luaAction:queryWhere(qb,w2)
    luaAction:queryDel(qb)

    --create new
    setMessage(listDao,table)
end

--
-- if exist(date,startTime,stopTime!=stop) del it & insert new
--
function mergeActivityMsg(listDao,ConfigInfo,table)
    t = table
    luaAction = ConfigInfo:getLuaAction()

    --check old msg
    today = "" .. os.date("%Y-%m-%d",os.time())
    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")
    qb = listDao:queryBuilder()
    qb2 = listDao:queryBuilder()

    w1 = Properties.Date:eq(today)
    --    the date_time MUST be different,so we don't need stype
--    w2 = Properties.Type:eq(t.stype)
    w3 = Properties.Start:eq(t.start)
    w4 = Properties.Stop:eq(t.stop)
    w5 = Properties.Stop:notEq(t.stop)

    --judge unique
    luaAction:queryWhere(qb,w1)
    luaAction:queryWhere(qb,w3)
    luaAction:queryWhere(qb,w4)
    n = luaAction:queryCount(qb)

    --if exist & not _FORCE_ update return;
    if __forceUpdate == false then 
        if n > 0 then
            log(" activity msg already exist:"..t.t1)
            return
        end
    end


    --del last item if update
    luaAction:queryWhere(qb2,w1)
    luaAction:queryWhere(qb2,w3)
    luaAction:queryWhere(qb2,w5)
    luaAction:queryDel(qb2)

    --create new
    setMessage(listDao,table)
end


--
-- if exist update ,not del & insert new
--
function mergeSleepMsg(listDao,ConfigInfo,table)
    t = table

    --del old msg
    qb = listDao:queryBuilder()
    luaAction = ConfigInfo:getLuaAction()
    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")

    today = "" .. os.date("%Y-%m-%d",os.time())
    w1 = Properties.Date:eq(today)
    w2 = Properties.Type:eq(t.stype)

    luaAction:queryWhere(qb,w1)
    luaAction:queryWhere(qb,w2)
    listItem = luaAction:queryLastItem(qb)

    if listItem ~= nil then
       log("already set sleep msg:".. listItem:getText1().. "change it")

       t.listItem = listItem
    end


    --create new
    setMessage(listDao,table)
end

--------------------------------------------------------------------------------------------------
--
--
--
--  Message generators
--
--
--
------------------------------------------------------------------------------------------------

-- 1001
function welcome(listDao,ConfigInfo)
    t1 = "Benvenuti in MiBand"
    t2 = "Breve tutorial"
    stype = "1001"

    strScript = "function doAction(context, luaAction) \
        ConfigInfo = luaAction:getConfigInfo()\
        ConfigInfo:setNewUser(false)\
        ConfigInfo:save()\
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.InstructionActivity');\
        context:startActivity(intent)\
    end"

    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript

    uniqueMsg(listDao,ConfigInfo,t)

end

-- 1002
function newUser(listDao,ConfigInfo)
    t1 = "Indossa MiBand"
    t2 = "Memorizzerò i dati delle attività per aiutarti nella tua salute"
    stype = "1002"

    strScript = ""

    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript

    uniqueMsg(listDao,ConfigInfo,t)
end

-- 1003
function unlockHint(listDao,ConfigInfo)
    t1 = "Usa MiBand per lo sblocco intelligente"
    t2 = "Un nuovo modo di sbloccare"
    stype = "1003"

    strScript = "function doAction(context, luaAction) \
        ConfigInfo = luaAction:getConfigInfo()\
        ConfigInfo:setShowUnlockInfo(false)\
        ConfigInfo:save()\
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.UnlockScreenHelperActivity');\
        context:startActivity(intent)\
    end"
--    strScript= "--http://3.html" -- this "--" prefix  will cause use default doaction or last doaction so it's very dangous Undefine action !!
--    uniqueMsg(listDao,ConfigInfo,t1,t2,stype,strScript)

    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript

    uniqueMsg(listDao,ConfigInfo,t)
end
function clearUnlockHint(listDao,ConfigInfo)
    qb = listDao:queryBuilder()
    luaAction = ConfigInfo:getLuaAction()
    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")

    today = "" .. os.date("%Y-%m-%d",os.time())
    stype = "1003" --magic number ,but u know it
    w1 = Properties.Date:eq(today)
    w2 = Properties.Type:eq(stype)

    luaAction:queryWhere(qb,w1)
    luaAction:queryWhere(qb,w2)
    luaAction:queryDel(qb)
end

--1004
function noData(listDao,ConfigInfo)
    msgTable = {
        "L\'essenza dello sport non è divertente, pur continuando abitudine duratura",
        "Decompressione Jogging può aiutare a essere felici, per tenervi di buon umore",
        "L'allenamento aerobico è quello di perdere peso, un importante mezzo di fisica, che include aerobica, correndo, pedalando biciclette",
        "Solo Un sonno profondo il 15% degli adulti e il 20% del tempo totale di sonno, saranno in media 90 minuti",
    }

    r = math.random(1,#msgTable)

    t = {}
    t.t1 = msgTable[r]
    t.t2 = ""
    t.stype = "1004"
    replaceMsgByType(listDao,ConfigInfo,t)
end

--1005
function clearUnbindMsg(listDao,ConfigInfo)
    qb = listDao:queryBuilder()
    luaAction = ConfigInfo:getLuaAction()
    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")

    today = "" .. os.date("%Y-%m-%d",os.time())
    stype = "1005" --magic number ,but u know it
    w1 = Properties.Date:eq(today)
    w2 = Properties.Type:eq(stype)

    luaAction:queryWhere(qb,w1)
    luaAction:queryWhere(qb,w2)
    luaAction:queryDel(qb)
end

function unbindHint(listDao,ConfigInfo)
    t = {}
    t.t1 = "Collega MiBand"
    t.t2 = "Dopo l'associazione MiBand registrerà i dati delle attività"
    t.stype = "1005"


    t.strScript = "function doAction(context, luaAction) \
        if luaAction:getIsBind() then\
            return\
        end\
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.SearchSingleBraceletActivity');\
        intent:setFlags(0x10008000);\
        context:startActivity(intent)\
    end";
--    t.strScript = "file://cheneeispig.html"

    replaceMsgByType(listDao,ConfigInfo,t)
end


--2001
function newRecord(listDao,ConfigInfo)
    rr = ConfigInfo:getNewRecordReport()
	step = rr:getSteps()
    if step < NEW_RECORD_MIN then -- if record steps < NEW_RECORD_MIN we don't display it
        return
    end

    t = os.time()
    m = os.date("%m",t)
    d = os.date("%d",t)

    t1 = "Congratulazioni, si crea il tuo record del più alto passeggiata"
    t2 = "Nuovo record"..step.."Passo, "..m.."Mese"..d.."Giorno"
    stype = "2001"
--    msg(listDao,t1,t2,stype)

    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.model.ShareListDelegateActivity');\
        luaAction:putExtra(intent,'REF_REPORT_DATA','"..rr:toJsonStr().."')\
        context:startActivity(intent)\
    end"
	replaceMsgByType(listDao,ConfigInfo,t)
end


--2002
function dayComplete(listDao,ConfigInfo)

-- XXX
-- qb:where() has problem not fixed yet !!!!
--
--[[
    Properties = luajava.newInstance("de.greenrobot.daobracelet.LuaListDao$Properties")

    w1 = Properties.Date:eq("2014-06-12")
    w2 = Properties.Type:eq("2002")

    qb = listDao:queryBuilder()

    log("11xxxxxx","e")
    listDao:queryBuilder():checkCondition(w1)
    log("12xxxxxx","e")

    -- XXX FC here !!
    w = listDao:queryBuilder():where(w1,w2)

    log("12xxxxxx","e")
    n = w(w1,w2);
 --   ]]


    t1 = "Congratulazioni, oggi hai raggiunto l'obiettivo!"
    t2 = ""
    stype = "2002"


--    uniqueMsg(listDao,ConfigInfo,t1,t2,stype)
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript =
    "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.DynamicDetailActivity');\
        luaAction:putExtra(intent,'Mode',0x01)\
        luaAction:putExtra(intent,'Action','RefCompleteGoal')\
        context:startActivity(intent)\
    end"

    uniqueMsg(listDao,ConfigInfo,t)
end

--2003
function weekComplete(listDao,ConfigInfo)
    t1 = "Congratulazioni, hai raggiunto l'obiettivo della settimana!"
    t2 = ""

    stype = "2003"
--    msg(listDao,t1,t2,stype)
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
--    setMessage(listDao,t)
    uniqueMsg(listDao,ConfigInfo,t)
end

--2004
function challenge(listDao,ConfigInfo)
    cr = ConfigInfo:getContinueReport()

    t1 = "Hai continuato"..cr:getContinueDays().."Giorni per raggiungere l\'obiettivo"
    if cr:getTodayComplete() ~= 1 then
        t1 = '截至昨天' .. t1
    end
    t2 = "Registrazione storia personale"..cr:getMaxContinueDays().."Giorni"
    stype = "2004"

--    uniqueMsg(listDao,ConfigInfo,t1,t2,stype)
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.model.ShareListDelegateActivity');\
        luaAction:putExtra(intent,'REF_REPORT_DATA','"..cr:toJsonStr().."')\
        context:startActivity(intent)\
    end"

--    uniqueMsg(listDao,ConfigInfo,t)
    replaceMsgByType(listDao,ConfigInfo,t)
end

--2005
-- challengefailed

--2006
function weekReport(listDao,ConfigInfo)
    wr = ConfigInfo:getWeekReport()

    t1 = "La scorsa settimana, hai camminato per un totale di"..wr:getSteps().."Passi"
    t2 = "Totale percorso"..(wr:getDistance() / 1000).."Km, consumo"..wr:getCalories().."Kcal"
    stype = "2006"

--    uniqueMsg(listDao,ConfigInfo,t1,t2,stype)
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.model.ShareListDelegateActivity');\
        luaAction:putExtra(intent,'REF_REPORT_DATA','"..wr:toJsonStr().."')\
        context:startActivity(intent)\
    end"

    uniqueMsg(listDao,ConfigInfo,t)
end

--2007
function monthReport(listDao,ConfigInfo)
    mr = ConfigInfo:getMonthReport()
    t1 = "Il mese scorso hai camminato per un totale di"..mr:getSteps().."passi"
    t2 = "Totale percorso"..(mr:getDistance() / 1000).."Km, consumo"..mr:getCalories().."Kcal"
    stype = "2007"

--    uniqueMsg(listDao,ConfigInfo,t1,t2,stype)
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.model.ShareListDelegateActivity');\
        luaAction:putExtra(intent,'REF_REPORT_DATA','"..mr:toJsonStr().."')\
        luaAction:putExtra(intent,'Mode',"..MODE_STEP..")\
        context:startActivity(intent)\
    end"

    uniqueMsg(listDao,ConfigInfo,t)
end

function getActivityScript(activityItem, t2)
    strScript = "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.DynamicDetailActivity');\
        luaAction:putExtra(intent,'Mode',0x01)\
        luaAction:putExtra(intent,'Action','DynamicView')\
        luaAction:putExtra(intent,'DynamicStartTime',"..activityItem:getStart()..")\
        luaAction:putExtra(intent,'DynamicEndTime',"..activityItem:getStop()..")\
        luaAction:putExtra(intent,'DynamicActiveTime',"..activityItem:getActiveTime()..")\
        luaAction:putExtra(intent,'DynamicStep',"..activityItem:getSteps()..")\
        luaAction:putExtra(intent,'DynamicStepDistance',"..activityItem:getDistance()..")\
        luaAction:putExtra(intent,'DynamicActivitySubTitle','"..t2.."')\
        luaAction:putExtra(intent,'DynamicActivityMode',"..activityItem:getMode()..")\
        context:startActivity(intent)\
    end"

    return strScript
end
--3001
function activityRun(listDao,ConfigInfo)
    activityItem = ConfigInfo:getActiveItem()

    time = activityItem:getStop() - activityItem:getStart()
    activeTime = nil
    m = time % 60
    h = (time - m) / 60

    if time < 60 then
        activeTime = time .. "verbale"
    elseif m == 0 then
        activeTime = h .. "ora"
    else
        activeTime = h.."ora"..m.."verbale"
    end

    timestring = getTimeString2(activityItem:getStart(),activityItem:getStop()).." "
    msgTable = {
        timestring.."Corsa"..(activityItem:getDistance() / 1000).."Km, Complimenti!",
        timestring.."Imbullonato" ..(activityItem:getDistance() / 1000).."Miglia, ottimo lavoro！",
        timestring.."Corsa".. activeTime .. ", ottima resistenza!",
    }

    r = math.random(1,#msgTable)

    t1 = msgTable[r]
    t2 = "Consumato"..activityItem:getCalories().."Kcal"..getCaloriesString(activityItem:getCalories())
    stype = "3001"

    strScript = getActivityScript(activityItem, t2)


    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript
    t.start = "".. activityItem:getStart()
    t.stop = "".. activityItem:getStop()

    mergeActivityMsg(listDao,ConfigInfo,t)
end

function getDistanceString(meter)
    if string.len(meter) > 3 then
        m2 = string.sub(meter,-3,-3) --1234 get 2
        m1 = string.sub(meter,1,-4)  --xxx234 get xxx

        if m2 ~= "0" then
            return ", "..m1.."."..m2.."公里"
        else
            return ", "..m1.."公里"
        end
    else
        return ", Totale"..activityItem:getDistance().."M"
    end
end
--3002
function activityWalk(listDao,ConfigInfo)
    activityItem = ConfigInfo:getActiveItem()

    timestring = getTimeString2(activityItem:getStart(),activityItem:getStop()).." "
    --XXXXXX meter to kiloMeter???
    t1 = timestring.."andare"..activityItem:getSteps().."passo"..getDistanceString(activityItem:getDistance())

--    t2 = msgTable[r]
    t2 = "Consumato"..activityItem:getCalories().."Kcal"..getCaloriesString(activityItem:getCalories())

    stype = "3002"

    strScript = getActivityScript(activityItem, t2)

    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript
    t.start = "".. activityItem:getStart()
    t.stop = "".. activityItem:getStop()

    mergeActivityMsg(listDao,ConfigInfo,t)
end

--3003
function activityActivity(listDao,ConfigInfo)
    activityItem = ConfigInfo:getActiveItem()


    timestring1 = getTimeString1(activityItem:getStop() - activityItem:getStart())
    timestring2 = getTimeString2(activityItem:getStart(),activityItem:getStop()).." "

    ----XXXX
    t1 = timestring2.."Attività del"..timestring1..getDistanceString(activityItem:getDistance())

    t2 = "Consumato"..activityItem:getCalories().."Kcal"..getCaloriesString(activityItem:getCalories())

    stype = "3003"

    strScript = getActivityScript(activityItem, t2)

--    mergeActivityMsg(listDao,ConfigInfo,t1,t2,stype,strScript,""..activityItem:getStart(),""..activityItem:getStop())
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript
    t.start = "".. activityItem:getStart()
    t.stop = "".. activityItem:getStop()

    mergeActivityMsg(listDao,ConfigInfo,t)
end


--4001
function sleepGood(listDao,ConfigInfo)
    sleepInfo = ConfigInfo:getSleepInfo()


    m = sleepInfo:getSleepCount() % 60
    h = (sleepInfo:getSleepCount() - m ) / 60
    t1 = "Ultima notte di sonno"..h.."ora"..m.."verbale, Buona notte"


    m2 = sleepInfo:getNonRemCount() % 60
    h2 = (sleepInfo:getNonRemCount() - m2) / 60
    t2 = "Sonno profondo"..h2.."ora"..m2.."verbale"

    stype = "4001"

    strScript = "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.DynamicDetailActivity');\
        luaAction:putExtra(intent,'Mode',0x10)\
        context:startActivity(intent)\
    end";

    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript

    mergeSleepMsg(listDao,ConfigInfo,t)
end

--4002
function sleepNormal(listDao,ConfigInfo)
    sleepInfo = ConfigInfo:getSleepInfo()

    m = sleepInfo:getSleepCount() % 60
    h = (sleepInfo:getSleepCount() - m ) / 60
    t1 = "Ultima notte di sonno"..h.."ora"..m.."verbale"

    m2 = sleepInfo:getNonRemCount() % 60
    h2 = (sleepInfo:getNonRemCount() - m2) / 60
    t2 = "Sonno profondo"..h2.."ora"..m2.."verbale"

    stype = "4001"
    strScript = "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.DynamicDetailActivity');\
        luaAction:putExtra(intent,'Mode',0x10)\
        context:startActivity(intent)\
    end";
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript

    mergeSleepMsg(listDao,ConfigInfo,t)
end

--4003
function sleepBad(listDao,ConfigInfo)
    sleepInfo = ConfigInfo:getSleepInfo()

    m = sleepInfo:getSleepCount() % 60
    h = (sleepInfo:getSleepCount() - m) / 60
    t1 = "Ultima notte di sonno"..h.."ora"..m.."verbale"

    m2 = sleepInfo:getNonRemCount() % 60
    h2 = (sleepInfo:getNonRemCount() - m2) / 60
    t2 = "Sonno profondo"..h2.."ora"..m2.."verbale"

    stype = "4001"
    strScript = "function doAction(context, luaAction) \
        local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.DynamicDetailActivity');\
        luaAction:putExtra(intent,'Mode',0x10)\
        context:startActivity(intent)\
    end";
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    t.strScript = strScript

    mergeSleepMsg(listDao,ConfigInfo,t)
end
--4004
function sleepJudge(listDao,ConfigInfo)
    sleepInfo = ConfigInfo:getSleepInfo()

    if sleepInfo:getSleepCount() < 30 then
        log("no sleep, U'd better go to bed!!","e")
        return
    end

    --bad
    if sleepInfo:getAwakeNum() >= 3 then
        sleepBad(listDao,ConfigInfo)
        return
    end
    if sleepInfo:getStopDateMin() < 270 then -- 4:30=4*60+30=270
        sleepBad(listDao,ConfigInfo)
        return
    elseif sleepInfo:getNonRemCount() < 60 then
        sleepBad(listDao,ConfigInfo)
        return
    elseif sleepInfo:getSleepCount() < 180 then
        sleepBad(listDao,ConfigInfo)
        return
    elseif sleepInfo:getNonRemCount() < ConfigInfo:getSleepAverageDeepTime() * 0.7 then
        sleepBad(listDao,ConfigInfo)
        return
    end

    --normal
    if sleepInfo:getAwakeNum() == 2 then
        sleepNormal(listDao,ConfigInfo)
        return
    elseif sleepInfo:getAwakeNum() == 1 and sleepInfo:getAwakeCount() > 10 then
        sleepNormal(listDao,ConfigInfo)
        return
    elseif sleepInfo:getNonRemCount() <= 90 then
        sleepNormal(listDao,ConfigInfo)
        return
    elseif sleepInfo:getSleepCount() < 420 then
        sleepNormal(listDao,ConfigInfo)
        return
    elseif sleepInfo:getNonRemCount() < ConfigInfo:getSleepAverageDeepTime() * 0.9 then
        sleepNormal(listDao,ConfigInfo)
        return
    end

    -- good
    sleepGood(listDao,ConfigInfo)
end


--5001
function batteryLow(listDao,ConfigInfo)
    t1 = "Batteria MiBand scarica"
    t2 = "Ricaricalo il prima possibile"

    stype = "5001"
--    msg(listDao,t1,t2,stype)

    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    setMessage(listDao,t)
end

--5002
function batteryVeryLow(listDao,ConfigInfo)
    t1 = "Bassa potenza il MiBand può spegnersi, si prega di ricaricare"
    t2 = ""

    stype = "5002"
--    msg(listDao,t1,t2,stype)
    t = {}
    t.t1 = t1
    t.t2 = t2
    t.stype = stype
    setMessage(listDao,t)
end

--5003
function notFoud(listDao,ConfigInfo)
    t = {}
    t.t1 = "Non riesci a trovare MiBand?"
    t.t2 = "Assicurarsi che non ci sono elettriche e bracciale accanto al telefono"

    t.stype = "5003"
    replaceMsgByType(listDao,ConfigInfo,t)
end
---------------------------------------------------
--
-- Function Tables (should below Function definitions
--
--------------------------------------------------
callbacks = {
    --默认文案
    {index = 1001,func = welcome},
    {index = 1002,func = newUser},
    {index = 1003,func = unlockHint},
    {index = 1004,func = noData},
    {index = 1005,func = unbindHint},


    --个人成就
    {index = 2001,func = newRecord},
    {index = 2002,func = dayComplete},
    {index = 2003,func = weekComplete},
    {index = 2004,func = challenge},

    {index = 2006,func = weekReport},
    {index = 2007,func = monthReport},


    --个人运动动态
    {index = 3001,func = activityRun},
    {index = 3002,func = activityWalk},
    {index = 3003,func = activityActivity},

    --睡眠动态
    {index = 4001,func = sleepGood},
    {index = 4002,func = sleepNormal},
    {index = 4003,func = sleepBad},
    {index = 4004,func = sleepJudge},

    --系统动态
    {index = 5001,func = batteryLow},
    {index = 5002,func = batteryVeryLow},
    {index = 5003,func = notFoud},
}
---------------------------------------------------
--
-- Main
--
--------------------------------------------------

--this only for test
function getEventMsgs(listDao,ConfigInfo,index)
   if index == 1 then  -- only for test
        t1 = "external/chenee.lua"
        t2 = "date: " .. os.date("%Y-%m-%d",os.time())

        stype = "1"
        msg(listDao,t1,t2,stype)
        return
    end

----------- test function ,
----------------------
--if true then return end
----------------------
--
--    if index == 1001 then welcome(listDao) end
    for i,calls in ipairs(callbacks) do
        _i = calls["index"]
        _f = calls["func"]
        if _i  == index then
            _f(listDao,ConfigInfo)
            return
        end
    end

end

function getDefaultMsgs(listDao, ConfigInfo)
    if ConfigInfo:getNewUser() then
        welcome(listDao,ConfigInfo)
--        newUser(listDao,ConfigInfo)
    else
        log("xxxxxxxxxxx not new user")
    end

    if ConfigInfo:getShowUnlockInfo() then
        unlockHint(listDao,ConfigInfo)
    else
        clearUnlockHint(listDao,ConfigInfo)
    end

    if false == ConfigInfo:getIsBind() then
        unbindHint(listDao,ConfigInfo)
    else
        clearUnbindMsg(listDao,ConfigInfo)
    end
--  ConfigInfo:setShowUnlockInfo(false)
--    ConfigInfo:setShowUnlockInfo(true)

end

function getAchievementMsgs(listDao, ConfigInfo)
    --new record
    if true == ConfigInfo:getShowNewRecord() then
        newRecord(listDao,ConfigInfo)
    end

    --complete daily gaol
    if true == ConfigInfo:getShowDayComplete() then
        dayComplete(listDao,ConfigInfo)
    end

    --show continue day
    if true == ConfigInfo:getShowContinue() then
        challenge(listDao,ConfigInfo)
    end

    --show weekreport
    if true == ConfigInfo:getShowWeekReport() then
        weekReport(listDao,ConfigInfo)
    end
    --show monthreport
    if true == ConfigInfo:getShowMonthReport() then
        monthReport(listDao,ConfigInfo)
    end
end

function getActivityMsgs(listDao, ConfigInfo)

    activityItem = ConfigInfo:getActiveItem()
    mode = activityItem:getMode()


    --activity
    if mode == 0 then
        activityActivity(listDao,ConfigInfo)
    end
    --walk
    if mode == 1 then
        activityWalk(listDao,ConfigInfo)
    end
    --run
    if mode == 2 then
        activityRun(listDao,ConfigInfo)
    end

end

function getSleepMsgs(listDao,ConfigInfo)
    if true == ConfigInfo:getShowSleep() then
        sleepJudge(listDao,ConfigInfo)
    end
end

function getSysInfoMsgs(listDao,ConfigInfo)
    if true == ConfigInfo:getShowBattery() then
        if ConfigInfo:getBattery() < 3 then
            batteryLow(listDao,ConfigInfo)
        elseif ConfigInfo:getBattery() < 7 then
            batteryVeryLow(listDao,ConfigInfo)
        end
    end

    if true == ConfigInfo:getShowNoFound() then
        notFoud(listDao,ConfigInfo)
    end
end


--default doAction ?? maybe DANGER !
function doAction(context, luaAction)
--    local intent = luaAction:getIntentFromString("cn.com.smartdevices.bracelet.ui.StatisticActivity")
--    context:startActivity(intent)
    log("default doAction called...")
end

function testAddItem(listDao)

    r = math.random(1,100)

    t = {}
    time = os.date("%X",os.time())
    t.t1 = r.."Benvenuti in MiBand ..." .. time
    t.t2 = "Premi per il tutorail"
    t.stype = "0001"
    t.index = "0001"
    t.right = ""..r

    setMessage(listDao,t)
end
function doAction2(context,luaAction,listDao)
    testAddItem(listDao)

--    luaAction:clearDB()

--    local intent = luaAction:getIntentFromString('cn.com.smartdevices.bracelet.ui.DynamicDetailActivity')
--    luaAction:putExtra(intent,'Mode',0x10)
--    context:startActivity(intent)

end

function launchIntent2(context, url)
--    log("url is:"..url,"e")

    -- new 一个java 实例
    local intent = luajava.newInstance("android.content.Intent")
    intent:addFlags(0x10000000)
    intent:setAction("android.intent.action.VIEW")

    -- bind 一个Java实例，调用static 方法
    local uri = luajava.bindClass("android.net.Uri")
    intent:setData(uri:parse(url))

end







