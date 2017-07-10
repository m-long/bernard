<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
  # Associations
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %>
<% end -%>
<% attributes.select(&:token?).each do |attribute| -%>
has_secure_token<% if attribute.name != "token" %> :<%= attribute.name %><% end %>
<% end -%>
<% if attributes.any?(&:password_digest?) -%>
  has_secure_password
<% end -%>

  # Validations
  ## Attr 1 validations
  ## Attr 2 validations

  # Custom Validations

  # Custom Methods

  # Private Methods
  private

end
<% end -%>
