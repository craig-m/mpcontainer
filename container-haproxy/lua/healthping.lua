-- send http response 

function lua_ping_server(applet)
    local response = "ha-pong\n"
    applet:set_status(200)
    applet:add_header("Server", "haproxy")
    applet:add_header("content-length", string.len(response))
    applet:add_header("content-type", "text/html")
    applet:start_response()
    applet:send(response)
end

core.register_service("lua_ping_server", "http", lua_ping_server)
