class AP01Account {

/**
 * @description List<Order> description
 * @return   return description
 */
    public void updateOrderNetAmout(Set<ID> setOrdId){
        List<Order> newOrder = new List<Order>();
	    for(Order o : [Select Id, NetAmount__c, TotalAmount, ShipmentCost__c FROM Order Where Id IN :setOrdId]){
	        o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
	        newOrder.add(o);
		}
		update newOrder;
    }

    public void updateAccountCA(set<ID> setAccId){
        Map<id,Account> accMap = new Map<id,Account>([select id, Chiffre_d_affaire__c from account where id in : setAccId]);
        List<Account> listAcc = new List<Account>();
        AggregateResult[] groupedResults= [SELECT accountId, SUM(TotalAmount)ca FROM Order where Status = 'Ordered' and AccountId in : setAccId group by AccountId];
        for (AggregateResult a : groupedResults){
            ID accountID = (id)a.get('accountId');
            Decimal ca = (Decimal)a.get('ca');
            Account acc = accMap.get(accountId);
            acc.Chiffre_d_affaire__c = ca;
            listAcc.add(acc);
        }
        update listAcc;
    }

 }
