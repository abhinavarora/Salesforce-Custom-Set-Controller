/**
 * Although Salesforce provides a class called StandardSetController, this class is needed because StandardSetController can only operate on SoObjects. 
 * There may be some situations where we would like to paginate our custom objects. This class does the same.
 */
public with sharing class CustomSetController
{
    public static Integer DEFAULT_PAGE_SIZE = 10; // Default Page size to use if no pageSize is specified
    
    private Integer pageSize;
    private List<Object> completeList;
    private List<List<Object>> pages;
    private Integer currentPageIndex;
    
    /**
     * Constructor for the Custom Set Controller. 
     * @param fullList List of objects which are to be Paginated. These can be any objects
     * @param pageSize Number of objects to be displayed per page.
     */
    public CustomSetController(List<Object> fullList, Integer pageSize)
    {
        if(fullList == null)
        	throw new NullValueNotAllowedException();
        
        this.completeList = fullList;
        this.pageSize = ((pageSize != null && pageSize > 0) ? pageSize :DEFAULT_PAGE_SIZE);
        this.pages = populatePages();
        this.currentPageIndex = 0;
    }
    
    private List<List<Object>> populatePages()
    {
        List<List<object>> pages = new List<List<Object>>();
        Integer count = 0;
        List<Object> page;
        
        // For Empty list create an empty page in the pages List and return
        if(this.completeList.size() == 0)
        {
            page = new List<Object>();
            pages.add(page);
            return pages;
        }
        
        // If list is not empty then populate the pages List
        for(Object o : this.completeList)
        {
            if(0 == count)
                page = new List<Object>();
            page.add(o);
            count++;
            
            if(this.pageSize == count)
            {
                count = 0;
                pages.add(page);
                page = null;
            }
        }
        if(0 != count)
        {
            count =0;
            pages.add(page);
            page = null;
        }
        
        return pages;
    }
    
    /**
     * Returns TRUE if the current page has a previous page. 
     * Returns FALSE if the current page is the first page
     */
    public Boolean getHasPrevious()
    {
        return (this.currentPageIndex > 0);
    }
    
    /**
     * Returns TRUE if the current page has a next page. 
     * Returns FALSE if the current page is the last page
     */
    public Boolean getHasNext()
    {
        return (this.currentPageIndex < (this.pages.size() - 1));
    }
    
    /**
     * Move to the next page
     */
    public void next()
    {
        if(this.getHasNext())
            this.currentPageIndex++;
    }
    
    /**
     * Move to the previous page
     */
    public void previous()
    {
        if(this.getHasPrevious())
            this.currentPageIndex--;
    }
    
    /**
     * Move to the first page
     */ 
    public void first()
    {
        this.currentPageIndex = 0;
    }
    
    /**
     * Move to the last page
     */
    public void last()
    {
        this.currentPageIndex = this.pages.size() - 1;
    }
    
    /**
     * Get objects that belong to the current page
     */
    public List<Object> getRecords()
    {
        return this.pages.get(this.currentPageIndex);
    }
    
    /**
     * Return current Page Number
     */
    public Integer getPageNumber()
    {
        return (this.currentPageIndex + 1);
    }
    
    /**
     * Returns the total number of pages
     */
    public Integer getPageCount()
    {
        if(completeList != null && completeList.size() > 0)
        {
            return Math.ceil((Double)completeList.size()/pageSize).intValue();
        }
        // Empty list will still have one page
        return 1;
    }
    
    /**
     * Returns TRUE if the current page is the first page otherwise FALSE
     */ 
    public Boolean isFirst()
    {
        return ( this.currentPageIndex == 0);
    }
    
    /**
     * Returns TRUE if the current page is the last page otherwise FALSE
     */ 
    public Boolean isLast()
    {
        return(this.currentPageIndex == (this.pages.size() - 1));
    }
    
    /*
     * Exception thrown when a null list is passed to the controller
     */
    public class NullValueNotAllowedException extends Exception
    {}
}