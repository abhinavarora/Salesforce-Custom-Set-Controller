@isTest
class CustomSetControllerTestClass
{

    /*
     * This class will be used to test the Custom Set Controller class whose job is to create pagination for any kind of list given to it.
     * It accepts 2 parameters : the List and the number of records per page.
     * Test Cases covered : 
     * 	1. Null List
     * 	2. Empty List
     * 	3. List.size() % recordsPerPage == 0
     * 	4. List.size() % recordsPerPage != 0
     * 	5. recordsPerPage not initialised
     */
    
    static testMethod void testCustomSetControllerCase1()
    {
        Test.startTest();
        try
        {
			CustomSetController setController = new CustomSetController(null,10);
        }
        catch(CustomSetController.NullValueNotAllowedException e)
        {
            System.assert(true,'A NullValueNotAllowedException was expected and was thrown');
            // Exit the test if the exception is thrown
            return;
        }
        
        System.assert(false,'A NullValueNotAllowedException was expected, but was not thrown.');
        
        Test.stopTest();
    }
    
    static testMethod void testCustomSetControllerCase2()
    {
        Test.startTest();
        CustomSetController setController;
        try
        {
             setController = new CustomSetController(new List<String>(),5);
        }
        catch(CustomSetController.NullValueNotAllowedException e)
        {
            System.assert(true,'A NullValueNotAllowedException was not expected and was thrown');
            // Exit the test if the exception is thrown
            return;
        }

		System.assertEquals(1, setController.getPageNumber(),'First page should always be number 1');
		System.assertEquals(0,setController.getRecords().size(),'Empty list, so number of records should be 0');
        System.assertEquals(false,setController.getHasNext(),'There will only be one page, so no next page');
        System.assertEquals(false,setController.getHasPrevious(),'There will only be one page, so no previous page');
        System.assertEquals(1, setController.getPageCount(),'There will only be 1 page');
        System.assertEquals(true, setController.isFirst(), 'Since there is only 1 page, this is the first page');
        System.assertEquals(true, setController.isLast(), 'Since there is only 1 page, this is the last page');
        
        setController.next();
        System.assertEquals(1, setController.getPageNumber(),'There is only 1 page, so next will not do anything');
        
        setController.previous();
        System.assertEquals(1, setController.getPageNumber(),'There is only 1 page, so previous will not do anything');
        
        setController.first();
        System.assertEquals(1, setController.getPageNumber(),'First page should always be number 1');
        
        setController.last();
        System.assertEquals(1, setController.getPageNumber(),'Only 1 page, so the last page is also 1');
        
        Test.stopTest();
    }
    
    static testMethod void testCustomSetControllerCase3()
    {
        List<String> records = new List<String>();
        // Create 21 records to be paginated
        for(Integer i = 0; i<21; i++)
            records.add('Record'+i);
        
        Test.startTest();
        
        CustomSetController setController;
        try
        {
             setController = new CustomSetController(records,7); // Page Size is 7 so that List.size() % recordsPerPage == 0
        }
        catch(CustomSetController.NullValueNotAllowedException e)
        {
            System.assert(true,'A NullValueNotAllowedException was not expected and was thrown');
            // Exit the test if the exception is thrown
            return;
        }
        
        System.assertEquals(1, setController.getPageNumber(),'First page should always be number 1');
		System.assertEquals(7,setController.getRecords().size(),'First Page is full, so it will have all 7 entries');
        System.assertEquals(true,setController.getHasNext(),'This will have more pages, as');
        System.assertEquals(false,setController.getHasPrevious(),'No Previous page as this is the last page');
        System.assertEquals(3, setController.getPageCount(),'There will be 3 pages');
        System.assertEquals(true, setController.isFirst(), 'This is the first page');
        System.assertEquals(false, setController.isLast(), 'This is not the last page');
        
        setController.next();
        System.assertEquals(2, setController.getPageNumber());
        System.assertEquals(false, setController.isFirst(), 'This is not the first page');
        System.assertEquals(false, setController.isLast(), 'This is not the last page');
        
        // Get records for Page 2
        List<Object> recs = setController.getRecords();
        //Validate the records
        for(Integer i =0; i<recs.size(); i++)
            System.assertEquals('Record'+(i+7),recs.get(i));
        
        setController.previous();
        System.assertEquals(1, setController.getPageNumber(),'We should come back to the first page');
        System.assertEquals(true, setController.isFirst(), 'This is the first page');
        System.assertEquals(false, setController.isLast(), 'This is not the last page');
        
        setController.last();
        System.assertEquals(3, setController.getPageNumber(),'3rd page should be the last page');
        System.assertEquals(false, setController.isFirst(), 'This is not the first page');
        System.assertEquals(true, setController.isLast(), 'This is the last page');
        
        setController.first();
        System.assertEquals(1, setController.getPageNumber());
        System.assertEquals(true, setController.isFirst(), 'This is the first page');
        System.assertEquals(false, setController.isLast(), 'This is not the last page');
        
        Test.stopTest();
    }
    
    static testMethod void testCustomSetControllerCase4()
    {
        List<String> records = new List<String>();
        // Create 25 records to be paginated
        for(Integer i = 0; i<25; i++)
            records.add('Record'+i);
        
        Test.startTest();
        
        CustomSetController setController;
        try
        {
             setController = new CustomSetController(records,7); // Page Size is 7 so that List.size() % recordsPerPage != 0
        }
        catch(CustomSetController.NullValueNotAllowedException e)
        {
            System.assert(true,'A NullValueNotAllowedException was not expected and was thrown');
            // Exit the test if the exception is thrown
            return;
        }
        
        System.assertEquals(1, setController.getPageNumber(),'First page should always be number 1');
		System.assertEquals(7,setController.getRecords().size(),'First Page is full, so it will have all 7 entries');
        System.assertEquals(true,setController.getHasNext(),'This will have more pages');
        System.assertEquals(false,setController.getHasPrevious(),'Since this is first page, so no previous page');
        System.assertEquals(4, setController.getPageCount(), 'There would be 4 pages');
        System.assertEquals(true, setController.isFirst(), 'This is the first page');
        System.assertEquals(false, setController.isLast(), 'This is not the last page');
        
        setController.next();
        System.assertEquals(2, setController.getPageNumber());
        System.assertEquals(false, setController.isFirst(), 'This is not the first page');
        System.assertEquals(false, setController.isLast(), 'This is not the last page');
        
        setController.previous();
        System.assertEquals(1, setController.getPageNumber(),'We should come back to the first page');
        System.assertEquals(true, setController.isFirst(), 'This is the first page');
        System.assertEquals(false, setController.isLast(), 'This is not the last page');
        
        setController.last();
        System.assertEquals(4, setController.getPageNumber(),'4th page should be the last page');
        System.assertEquals(false, setController.isFirst(), 'This is not the first page');
        System.assertEquals(true, setController.isLast(), 'This is the last page');
        
        setController.first();
        System.assertEquals(1, setController.getPageNumber());
        System.assertEquals(true, setController.isFirst(), 'This is the first page');
        System.assertEquals(false, setController.isLast(), 'This is not the last page');
        
        setController.last();
        System.assertEquals(4, setController.getRecords().size(),'Last page should have only 4 records');
        System.assertEquals(false, setController.isFirst(), 'This is not the first page');
        System.assertEquals(true, setController.isLast(), 'This is the last page');
        
        Test.stopTest();
    }
    
    static testMethod void testCustomSetControllerCase5()
    {
        List<String> records = new List<String>();
        // Create 20 records to be paginated
        for(Integer i = 0; i<21; i++)
            records.add('Record'+i);
        
        Test.startTest();
        
        CustomSetController setController;
        try
        {
             setController = new CustomSetController(records,null); // Page Size is null, so it should choose default
        }
        catch(CustomSetController.NullValueNotAllowedException e)
        {
            System.assert(true,'A NullValueNotAllowedException was not expected and was thrown');
            // Exit the test if the exception is thrown
            return;
        }
        
		System.assertEquals(1, setController.getPageNumber(),'First page should always be number 1');
		System.assertEquals(CustomSetController.DEFAULT_PAGE_SIZE,setController.getRecords().size());
        
        try
        {
             setController = new CustomSetController(records,0); // Page Size is 0, so it should choose default
        }
        catch(CustomSetController.NullValueNotAllowedException e)
        {
            System.assert(true,'A NullValueNotAllowedException was not expected and was thrown');
            // Exit the test if the exception is thrown
            return;
        }
        
		System.assertEquals(1, setController.getPageNumber(),'First page should always be number 1');
		System.assertEquals(CustomSetController.DEFAULT_PAGE_SIZE,setController.getRecords().size());
        
        try
        {
             setController = new CustomSetController(records,-8); // Page Size is negative, so it should choose default
        }
        catch(CustomSetController.NullValueNotAllowedException e)
        {
            System.assert(true,'A NullValueNotAllowedException was not expected and was thrown');
            // Exit the test if the exception is thrown
            return;
        }
        
		System.assertEquals(1, setController.getPageNumber(),'First page should always be number 1');
		System.assertEquals(CustomSetController.DEFAULT_PAGE_SIZE,setController.getRecords().size());
        
        
        Test.stopTest();
    }
}