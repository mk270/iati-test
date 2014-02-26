#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#include <libxml/tree.h>
#include <libxml/parser.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

void print_xpath_nodes(xmlNodeSetPtr nodes, FILE* output);

int execute_xpath_string(const char *filename, char *xpathExp)
{
	return execute_xpath_expression(filename, BAD_CAST xpathExp);
}

int execute_xpath_str_on_memory(const char *s, char *xpathExp)
{
	int len;
	xmlDocPtr doc;

	len = strlen(s);
	fprintf(stderr, "%d [%s]\n", len, xpathExp);
	doc = xmlParseMemory(s, len);
	if(doc == NULL) {
		return -1;
	}
	return execute_xpath_on_doc(doc, BAD_CAST xpathExp);
}

int execute_xpath_expression(const char* filename, const xmlChar* xpathExpr)
{
    xmlDocPtr doc;

    assert(filename);
    assert(xpathExpr);

    doc = xmlParseFile(filename);
    if (doc == NULL) {
		fprintf(stderr, "Error: unable to parse file \"%s\"\n", filename);
		return(-1);
    }
	return execute_xpath_on_doc(doc, xpathExpr);
}

int execute_xpath_on_doc(xmlDocPtr doc, const xmlChar *xpathExpr)
{
    xmlXPathContextPtr xpathCtx; 
    xmlXPathObjectPtr xpathObj; 
	int size;
	xmlNodeSetPtr nodes;
	
    xpathCtx = xmlXPathNewContext(doc);
    if(xpathCtx == NULL) {
        fprintf(stderr, "Error: unable to create new XPath context\n");
        xmlFreeDoc(doc); 
        return(-1);
    }
    
    xpathObj = xmlXPathEvalExpression(xpathExpr, xpathCtx);
    if(xpathObj == NULL) {
        fprintf(stderr,
				"Error: unable to evaluate xpath expression \"%s\"\n", 
				xpathExpr);
        xmlXPathFreeContext(xpathCtx); 
        xmlFreeDoc(doc); 
        return(-1);
    }

	nodes = xpathObj->nodesetval;
    size = (nodes) ? nodes->nodeNr : 0;
	   

	/*
    print_xpath_nodes(xpathObj->nodesetval, stdout);
	*/
    /* Cleanup */
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx); 
    xmlFreeDoc(doc); 
    
    return(size);
}

void print_xpath_nodes(xmlNodeSetPtr nodes, FILE* output)
{
    xmlNodePtr cur;
    int size;
    int i;
    
    assert(output);
    size = (nodes) ? nodes->nodeNr : 0;
    
    fprintf(output, "Result (%d nodes):\n", size);
    for(i = 0; i < size; ++i) {
	assert(nodes->nodeTab[i]);
	
	if(nodes->nodeTab[i]->type == XML_NAMESPACE_DECL) {
	    xmlNsPtr ns;
	    
	    ns = (xmlNsPtr)nodes->nodeTab[i];
	    cur = (xmlNodePtr)ns->next;
	    if(cur->ns) { 
	        fprintf(output, "= namespace \"%s\"=\"%s\" for node %s:%s\n", 
		    ns->prefix, ns->href, cur->ns->href, cur->name);
	    } else {
	        fprintf(output, "= namespace \"%s\"=\"%s\" for node %s\n", 
		    ns->prefix, ns->href, cur->name);
	    }
	} else if(nodes->nodeTab[i]->type == XML_ELEMENT_NODE) {
	    cur = nodes->nodeTab[i];   	    
	    if(cur->ns) { 
    	        fprintf(output, "= element node \"%s:%s\"\n", 
		    cur->ns->href, cur->name);
	    } else {
    	        fprintf(output, "= element node \"%s\"\n", 
		    cur->name);
	    }
	} else {
	    cur = nodes->nodeTab[i];    
	    fprintf(output, "= node \"%s\": type %d\n", cur->name, cur->type);
	}
    }
}

int succ(int a) {
	return a + 1;
}
