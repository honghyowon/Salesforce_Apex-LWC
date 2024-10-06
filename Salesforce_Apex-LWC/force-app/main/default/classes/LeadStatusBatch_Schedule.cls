public with sharing class LeadStatusBatch_Schedule implements Schedulable {
    public void execute(SchedulableContext SC) {
        LeadStatusBatch batch = new LeadStatusBatch();
        Database.executeBatch(batch, 200);
    }
}

// LeadStatusBatch_Schedule scheduler = new LeadStatusBatch_Schedule();
// String sch = '0 0 15 * * ?'; // 매일 15시 실행
// System.schedule('LeadStatusBatch_Schedule', sch, scheduler);