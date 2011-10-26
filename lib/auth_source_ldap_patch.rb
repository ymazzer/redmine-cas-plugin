require_dependency 'auth_source_ldap'

module AuthSourceLdapPatch
   def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
   end

   module ClassMethods
   end

   module InstanceMethods
      def get_user_custom_attributes(login)
	 ldap_con = initialize_ldap_con(self.account, self.account_password)
	 login_filter = Net::LDAP::Filter.eq( self.attr_login, login )
	 object_filter = Net::LDAP::Filter.eq( "objectClass", "*" )
	 attrs = {}

	 ldap_con.search( :base => self.base_dn,
               		  :filter => object_filter & login_filter,
	                  :attributes=> search_attributes) do |entry|

	   attrs = get_user_attributes_from_ldap_entry(entry)
	end
	attrs.except(:dn)
      end
   end
end
