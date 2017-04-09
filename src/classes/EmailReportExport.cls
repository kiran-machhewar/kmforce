public class EmailReportExport implements Reports.NotificationAction {

    public void execute(Reports.NotificationActionContext context) {
        this.createCSVFileAndSendEmail(context.getReportInstance().getReportResults());
 
    }

    private void createCSVFileAndSendEmail(Reports.ReportResults results){
		//Get header column labels
		MAP<String,Reports.DetailColumn> headerColumnMap = results.getReportExtendedMetadata().getDetailColumnInfo();

        List<String> headerColumns = new List<String>();
        for(String columnName : results.getReportMetadata().getDetailColumns()){
        	headerColumns.add(headerColumnMap.get(columnName).getLabel());
        }
        String csvFile = '"'+String.join(headerColumns,'","')+'"'; // double quotes are used to make csv file comma safe
        
        /** Create the Data part **/        
        for( Reports.ReportFact reportFact :  results.getFactMap().values()){
        	Reports.ReportFactWithDetails reportFactWithDetails = (Reports.ReportFactWithDetails)reportFact;
        	List<String> rowData = new List<String>();

        	for(Reports.ReportDetailRow reportDetailRow : reportFactWithDetails.getRows()){
        		rowData.clear();
        		for(Reports.ReportDataCell reportDataCell : reportDetailRow.getDataCells()){
        			if(reportDataCell.getValue() != null){
        				rowData.add(reportDataCell.getLabel());	
        			}else{
        				rowData.add('');
        			}
        			
        		}
        		csvFile += '\n"'+String.join(rowData,'","')+'"';
        	}       	

        }

		Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
		csvAttachment.setFileName(results.getReportMetadata().getName()+'.csv');
		csvAttachment.setBody(Blob.valueOf(csvFile));
		Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
		email.setSubject(results.getReportMetadata().getName()+' CSV');
		email.setTargetObjectId(UserInfo.getUserId());
		email.setSaveAsActivity(false); 
		email.setPlainTextBody('Hi,\nPlease consider the attached report export.\n Thanks,\nSalesforce');
		email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
		Messaging.SendEmailResult [] sendEmailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
		System.debug('sendEmailResult-->'+sendEmailResult);
        System.debug('CSV File-->\n'+csvFile);

	}
}