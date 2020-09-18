-- send http response 

function lua_server(applet)
    local response = "Hello from Lua!\n"
    applet:set_status(200)
    applet:start_response()
    applet:send(response)
end

core.register_service("lua_server", "http", lua_server)