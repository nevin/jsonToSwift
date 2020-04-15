public struct AppKeys: Codable {<% for @variable in @variables %>
    public var <%= @variable.name %>: <%= @variable.type%> = "<%=@variable.value%>"<% end %>
}