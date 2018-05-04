<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xb="http://com/exlibris/digitool/repository/api/xmlbeans"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="yes"/>

    <!-- Identity template, copies everything as is -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Override for target element -->
    <xsl:template match="mets:mets">
        <!-- Copy the element -->
        <mets:mets>
            
            <xsl:attribute name="OBJID">
                <xsl:value-of select="concat('http://hdl.handle.net/', handle)"/>
            </xsl:attribute>
            <xsl:text>
               
            </xsl:text>
            
            <xsl:copy-of select="pid"/>
            <xsl:apply-templates/>
        </mets:mets>
    </xsl:template>
    <xsl:template match="handle">

   <!--     <mets:amdSec>
            <mets:digiprovMD ID="dp01">
                <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="preservation_md">
                    <mets:xmlData>
                        <premis>
                            <xsl:apply-templates/>
                        </premis>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:digiprovMD>
        </mets:amdSec>-->
        
    </xsl:template>
    <xsl:template match="xb:digital_entity">
        <!-- And everything inside it -->
        <xsl:apply-templates select="@* | *"/>

    </xsl:template>



    <xsl:template match="mods:mods">
        <!-- Copy the element -->
        <xsl:copy>
            <!-- And everything inside it -->
            <xsl:apply-templates select="@* | *"/>

        </xsl:copy>

    </xsl:template>

    <xsl:template match="pid"/>

    <!--<xsl:template match="premis"/>-->



    <xsl:template match="mets:fileGrp[@USE='reference image']"/>

    <xsl:template match="mets:FLocat">
    <!--    <xsl:variable name="filename">

            <xsl:value-of select="ancestor::mets:mets/descendant::mods:identifier"/>
        </xsl:variable>

        <mets:Flocat>
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="concat('file://streams/',$filename,'.jpg')"/>
            </xsl:attribute>
        </mets:Flocat>-->
    </xsl:template>
    <xsl:template match="mets:structMap/mets:div/mets:div">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
