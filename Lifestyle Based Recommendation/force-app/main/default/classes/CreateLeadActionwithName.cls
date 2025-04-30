public with sharing class CreateLeadActionwithName {
    @InvocableMethod(label='Create Lead for property' description='Creates a new Lead record based on customer data.')
    public static List<LeadResult> createLead(List<LeadInput> inputs) {
        List<LeadResult> results = new List<LeadResult>();

        for (LeadInput input : inputs) {
            LeadResult result = new LeadResult();
            try {
                // Validate required fields
                if (String.isBlank(input.fullName) || String.isBlank(input.email)) {
                    throw new IllegalArgumentException('Name and Email are required.');
                }

                // Split full name into first and last name
                String firstName = '';
                String lastName = '';
                List<String> nameParts = input.fullName.trim().split(' ');

                if (nameParts.size() >= 2) {
                    firstName = nameParts[0];
                    lastName = nameParts[1];
                } else {
                    lastName = nameParts[0];
                }

                String queueId = UserInfo.getUserId();

              /*  if (!String.isBlank(input.City)) {
                    Group grp = [SELECT Id FROM Group WHERE Name LIKE :('%' + input.City + '%') LIMIT 1];
                    queueId = grp.Id;
                } */

                // Create Lead record
                Lead newLead = new Lead(
                    FirstName = firstName,
                    LastName = lastName,
                    Email = input.email,
                    Phone = input.phone,
                    Company = input.company
                    //OwnerId = queueId
                );
                insert newLead;

                result.success = true;
                result.leadId = newLead.Id;
            } catch (Exception e) {
                result.success = false;
                result.errorMessage = e.getMessage();
            }
            results.add(result);
        }
        return results;
    }

    public class LeadInput {
        @InvocableVariable(label='Full Name' required=true description='The full name of the customer.')
        public String fullName;

        @InvocableVariable(label='Email' required=true description='The email address of the customer.')
        public String email;

        @InvocableVariable(label='Phone' description='The phone number of the customer.')
        public String phone;

        @InvocableVariable(label='Company' description='The company name associated with the customer.')
        public String company;

        @InvocableVariable(label='City' description='The City customer is looking property in.')
        public String City;
    }

    public class LeadResult {
        @InvocableVariable(label='Success' description='Indicates whether the Lead creation was successful.')
        public Boolean success;

        @InvocableVariable(label='Lead ID' description='The ID of the created Lead record.')
        public Id leadId;

        @InvocableVariable(label='Error Message' description='The error message if the Lead creation failed.')
        public String errorMessage;
    }
}