public with sharing class EmailLimitChecker {

    @InvocableMethod(label='Check Email Limits')
    public static List<EmailLimitResult> checkEmailLimits(List<EmailLimitResult> dummyInput) {
        Integer used = Limits.getEmailInvocations();
        Integer allowed = Limits.getLimitEmailInvocations();

        EmailLimitResult result = new EmailLimitResult();
        result.allowed = (used < allowed) ? 1 : 0;
        System.debug('Email Invocations Used(Test In Flow): ' + result.allowed);
        return new List<EmailLimitResult>{ result };
    }

}