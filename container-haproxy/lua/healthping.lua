-- send http response 

function lua_ping_server(applet)
    local response = "pong\n"
    applet:set_status(200)
    applet:start_response()
    applet:send(response)
end

core.register_service("lua_ping_server", "http", lua_ping_server)