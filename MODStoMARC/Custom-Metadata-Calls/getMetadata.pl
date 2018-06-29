#!/usr/bin/perl -w
   
use strict;
use SOAP::Lite;
use FileHandle;
use LWP::Simple;
use XML::XPath;
use XML::LibXSLT;
use XML::LibXML;
use utf8;
use Encode;

    showUsage()
	if scalar(@ARGV) != 3;
	
    my ($query, $deOutput, $mdType) =  @ARGV;

	main();
	de_to_mods_extension();

#-----------------------------------------------------------------------------

sub de_to_mods_extension
{
    my $file =  $deOutput . '\\' . 'output' . '.xml'; 
    my $deFH = new FileHandle();
    $deFH->open($file);   #
    $deFH->binmode(':utf8');
    read $deFH, my $file_content, -s $deFH;		
    $deFH->close();   


    my $xslStylesheet = 'step2.xsl';


	my $parser = XML::LibXML->new();
	my $xslt = XML::LibXSLT->new();

	my $source = $parser->load_xml(string => $file_content);
	my $xsltDoc = $parser->load_xml(location => $xslStylesheet);
	
	my $xsltStyle = $xslt->parse_stylesheet($xsltDoc);
	my $result = $xsltStyle->transform($source, XML::LibXSLT::xpath_to_string);  
	$result = $xsltStyle->output_as_chars($result);

		
    $deFH->open("> $file");
    $deFH->binmode(':utf8');

    print $deFH $result;
    $deFH->close();



}

#-----------------------------------------------------------------------------


sub main {
    		    
    $mdType = lc $mdType;
    
    my $xslStylesheet = 'extractMDfromCDATA-entire-DE-object.xsl';
    my $general = readXML('general.xml');
    my $deQuery = readXML($query);
    my $deCall = readXML('call.xml');    
    
    my $dxproxy = 'http://dcollections.bc.edu/de_repository_web/services/DigitalEntityExplorer';
    my $dmproxy = 'http://dcollections.bc.edu/de_repository_web/services/DigitalEntityManager';
    
    mkdir ("$deOutput");

    my $file = $deOutput . '\\' . 'output' . '.xml';  
    my $deFH = new FileHandle();
	
    $deFH->open("> $file");
    $deFH->binmode(':utf8');
    print $deFH '<results>';

    my $result = (SOAP::Lite
	-> uri('DigitalEntityExplorer')
        -> proxy($dxproxy)
	-> digitalEntitySearch($general, $deQuery)
        -> result);
    
    while ( $result =~ /pid>(\d+)\</g) {
	
	my $pid = $1;
	
	my $newdeCall;
	($newdeCall = $deCall) =~ s/#####/$pid/;
	
        my $digitalEntity = SOAP::Lite
          -> uri('DigitalEntityManager')
          -> proxy($dmproxy)
          -> encoding('UTF-8')         
          -> digitalEntityCall($general, $newdeCall)
          -> result;   

	my $parser = XML::LibXML->new();
	my $xslt = XML::LibXSLT->new();

	my $source = $parser->load_xml(string => $digitalEntity);
	my $xsltDoc = $parser->load_xml(location => $xslStylesheet);
	
	my $xsltStyle = $xslt->parse_stylesheet($xsltDoc);
	my $result = $xsltStyle->transform($source, XML::LibXSLT::xpath_to_string(mdType => $mdType));  
	
   
	$result = $xsltStyle->output_as_chars($result);
	$result =~ s/ xsi\:type\=\"file\"//; #fix bad premis namespace
	$result =~ s/ version\=\"2\.0\" xsi\:schemaLocation="info\:lc\/xmlns\/premis\-v2 http\:\/\/www\.loc\.gov\/standards\/premis\/premis\.xsd\"//;
	$result =~ s/ xmlns\=\"info\:lc\/xmlns\/premis\-v2\" xmlns\:xsi\=\"http\:\/\/www\.w3\.org\/2001\/XMLSchema\-instance\"//;

#<object xmlns="http://www.loc.gov/standards/premis">

        

	




	print $deFH $result;

    }
    print $deFH '</results>';
    $deFH->close();

	
}
#-----------------------------------------------------------------------------
sub readXML
{
    my $file = shift;
    my $fh = new FileHandle();
    $fh->open($file);
    $fh->binmode(':utf8');	
    return join "", $fh->getlines();

}

#-----------------------------------------------------------------------------
sub showUsage
{
    print "\nUsage:\n\n";
    print "getMetadata.pl queryfile output metadata\n\n";
    print "Where\nqueryfile is XML file containing DigiTool Query\noutput is directory for output\nmetadata is Metadata type to extract (mods, marc, dc, etdms)\n";
    exit 1;
}
