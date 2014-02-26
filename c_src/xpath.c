#include <stdio.h>

#include <libxml/tree.h>
#include <libxml/xpath.h>

int  execute_xpath_string(const char* filename, const xmlChar* xpathExpr);
void print_xpath_nodes(xmlNodeSetPtr nodes, FILE* output);

int 
main(int argc, char **argv) {
    /* Parse command line and process file */
    if((argc < 3) || (argc > 4)) {
	fprintf(stderr, "Error: wrong number of arguments.\n");
	return(-1);
    } 
    
    /* Init libxml */     
    xmlInitParser();
    LIBXML_TEST_VERSION

    /* Do the main job */
    if(execute_xpath_string(argv[1], argv[2]) < 0) {
	return(-1);
    }

    /* Shutdown libxml */
    xmlCleanupParser();
    
    return 0;
}
