@isTest
private class TestUpdateAccountCA {
    @isTest static void testUpdateAccountCA() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
        Product2 pd2 = new Product2(Name = 'Pantalon bleu XXL', Family = 'Pantalon');
        Insert pd2;
        
        //Create the PricebookEntry
        PricebookEntry pbe1 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 20,
            IsActive = true
        );
        Insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd2.Id,
            UnitPrice = 50,
            IsActive = true
        );
        Insert pbe2;
        
        List<Order> listOrd = new List<Order>();
        Order o1 = new Order(AccountId = acc1.Id, EffectiveDate=System.today(), Status='Draft', Pricebook2Id = Test.getStandardPricebookId(), ShipmentCost__c=5.00);
        insert o1;
        listOrd.add(o1);
        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe1.Id, Quantity=1, UnitPrice=20 );
        insert oi1;
        o1.Status = 'Ordered';
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe2.Id, Quantity=2, UnitPrice=50);
        insert oi2;
        
        Order o2 = new Order(AccountId = acc1.Id, EffectiveDate=System.today(), Status='Draft', Pricebook2Id = Test.getStandardPricebookId(), ShipmentCost__c=5.00);
        insert o2;
        o2.Status = 'Ordered';
        OrderItem oi3 = new OrderItem (OrderId = o2.Id, PricebookEntryId = pbe1.Id, Quantity=10, UnitPrice = 18);
        insert oi3;
        OrderItem oi4 = new OrderItem (OrderId = o2.Id, PricebookEntryId = pbe2.Id, Quantity=20, UnitPrice = 35);
        insert oi4;
        listOrd.add(o2);
        BatchUpdateAccounts b = new BatchUpdateAccounts();
        Test.startTest();
        update listOrd;
        update acc1;
        Database.executeBatch(b, 200);
        Test.stopTest();
        Account updatedAcc1 = [select Id, Chiffre_d_affaire__c from Account where Id = :acc1.Id];
        System.assertEquals(1000, updatedAcc1.Chiffre_d_affaire__c);
        Order updatedO1 = [select Id, TotalAmount, NetAmount__c from Order where Id = :o1.Id];
        System.debug(updatedO1.TotalAmount);
        System.assertEquals(115, updatedO1.NetAmount__c);
        Order updatedO2 = [select Id, NetAmount__c from Order where Id = :o2.Id];
        System.assertEquals(875, updatedO2.NetAmount__c);  
    }
    
}
