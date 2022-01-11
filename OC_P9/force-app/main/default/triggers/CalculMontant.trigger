trigger CalculMontant on Order (before update, after update) {
    if (Trigger.isBefore){
       AP01Order.updateOrderNetAmout(Trigger.new);
    }
	else{
			AP01Account.UpdateAccountCA((new Map<Id,Order>(Trigger.new)).keySet());
		}
}