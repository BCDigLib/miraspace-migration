<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xb="http://com/exlibris/digitool/repository/api/xmlbeans"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:output encoding="UTF-8" indent="no" method="xml" omit-xml-declaration="yes"/>



    <!-- Identity template, copies everything as is -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Override for target element -->
    <xsl:template match="results">
        <!-- Copy the element -->
        <mods:modsCollection>
            <xsl:apply-templates/>

        </mods:modsCollection>
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

    <xsl:template match="creation_date"/>
    <xsl:template match="mods:extension">
        <xsl:text>&#xa;</xsl:text>
        <xsl:copy>
            <!-- And everything inside it -->
            <xsl:apply-templates select="@* | *"/>
            <xsl:text>&#xa;</xsl:text>
            <pid>
            <xsl:value-of select="ancestor::mods:mods/preceding-sibling::pid"/>
            </pid>
            <xsl:text>&#xa;</xsl:text>
            <creation_date>
                <xsl:value-of select="ancestor::mods:mods/preceding-sibling::creation_date"/>
            </creation_date>
            <xsl:text>&#xa;</xsl:text>
            <digital_surrogates>
                <xsl:value-of select="ancestor::mods:mods/preceding-sibling::mets:fileSec/mets:fileGrp/mets:file[position() = last()]/@SEQ"/>
            </digital_surrogates>
            <xsl:text>&#xa;</xsl:text>
            <hdl>
                <xsl:value-of select="ancestor::mods:mods/following-sibling::premis/descendant::objectIdentifierValue"/>            
            </hdl>
            <xsl:text>&#xa;</xsl:text>
            <thumbnail>
                <xsl:value-of select="ancestor::mods:mods/following-sibling::thumbnail"/>            
            </thumbnail>
        </xsl:copy>
        
        
    </xsl:template>
    <xsl:template match="mets:fileSec"/>
    <xsl:template match="premis"/>
    <xsl:template match="thumbnail"/>




</xsl:stylesheet>
