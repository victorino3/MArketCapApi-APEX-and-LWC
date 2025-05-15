public with sharing class EmailLimitChecker {
    @InvocableMethod(label='checkEmailLimits' description='Returns true if limit is not hit.')
    public static Boolean checkEmailLimits() {
        Integer used = Limits.getEmailInvocations();
        Integer allowed = Limits.getLimitEmailInvocations();
        if (used < allowed) {
            System.debug('Email limit is within the allowed range. Used: ' + used + ', Allowed: ' + allowed);
            return true;
        } else {
            System.debug('Email limit exceeded! Used: ' + used + ', Allowed: ' + allowed);
            return false;
        }
    }
}