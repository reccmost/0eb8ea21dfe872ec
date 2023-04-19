local TaskTipMessage = [[
<ol type="1">
    <li>在输入框中搜索<font color=red>宠物托运</font></li>
    <li>在广告列表中找到<font color=blue>宠必达-宠物托运</font>的内容，他的网站为<font color=red>m.chongbida.com</font></li>
    <li>点击后将自动完成</li>
</ol>
<br>
随时在右上角的菜单中查看提示<br>
如果第一页没有找到，可以尝试翻页
]]

local TaskCurrentStep = 0
local DatabaseKeyName = "LATEST_TASK_TIMESTAMP"

function isCanDoTask()
    ---@type string
    local code = Database.getKey(DatabaseKeyName)
    if code == nil then
        Database.setKey(DatabaseKeyName, string.format("%d", os.time()))
        return nil
    elseif os.time() - tonumber(code) > 3 * 60 * 60 * 24 then
        return { title = "百度一下", url = "https://www.baidu.com" }
    else
        return nil
    end
end

function onAppReady()
    if code == nil then
        Android.log("dialog code is nil")
    else
        Android.log("dialog code is not nil: " .. code)
    end
end

function onWebViewCreated(webView)
    Android.dialog("提示", TaskTipMessage, "开始")
end

function onWebViewPageFinished(url)
    Android.log(string.format('TaskCurrentStep:%d onWebViewPageFinished: %s', TaskCurrentStep, url))
    if string.find(url, 'word=%E5%AE%A0%E7%89%A9%E6%89%98%E8%BF%90') ~= -1 and TaskCurrentStep == 0 then
        TaskCurrentStep = 1
    elseif url == "https://m.chongbida.com/" and TaskCurrentStep == 1 then
        TaskCurrentStep = 2
        Database.setKey(DatabaseKeyName, string.format("%d", os.time()))
        Android.log(string.format("onWebViewPageFinished TaskCurrentStep:%d onWebViewPageFinished: %s", TaskCurrentStep, url))
        Android.dialog("提示", "恭喜你完成任务<br>万分感谢您的支持。<br><br>您现在可以关闭此页面继续正常使用功能了。", "确定")
        Android.finish()
    end
end

function onWebViewMenuTipsClick()
    if TaskCurrentStep == 0 then
        Android.dialog("提示", TaskTipMessage, "确定")
    elseif TaskCurrentStep == 1 then
        Android.dialog("提示", [[
        在广告列表中找到<font color=blue>宠必达-宠物托运</font>的内容，他的网站为<font color=red>m.chongbida.com</font><br>
        <br>
        如果第一页没有找到，可以尝试翻页
        ]], "确定")
    end
end


