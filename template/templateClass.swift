public class <%= @className%> {
    <% for @variable in @variables %>
    private var <%= @variable.name %>: <%= @variable.type%> = "<%=@variable.value%>"<% end %>

    public init() {}
    <% for @variable in @variables %>
    public get<%= @variable.function %>() -> <%= @variable.type%> {
        return self.<%= @variable.name %>
    }
    <% end %>
}