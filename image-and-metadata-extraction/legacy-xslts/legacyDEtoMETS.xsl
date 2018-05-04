<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xb="http://com/exlibris/digitool/repository/api/xmlbeans"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="info:lc/xmlns/premis-v2 https://www.loc.gov/standards/premis/v2/premis-v2-3.xsd"
    exclude-result-prefixes="xsi xb mods mets">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="yes"/>
    <xsl:param name="mdType"/>

    <xsl:template match="/xb:digital_entity_call/xb:digital_entity">
        <mets:mets>
            <xsl:text>
                
            </xsl:text>
            <pid>
                <xsl:value-of select="pid"/>
            </pid>
            <xsl:apply-templates/>
        </mets:mets>
    </xsl:template>

    <xsl:template match="mds/md">
        <xsl:choose>
            <xsl:when test="name='mets_section' and type='metsHdr'">
                <xsl:apply-templates select="value"/>
            </xsl:when>
            <xsl:when test="name='preservation'">
                <xsl:apply-templates select="value"/>
            </xsl:when>
            <xsl:when test="name='descriptive'">
                <mets:dmdSec>
                    <mets:mdWrap MIMETYPE="text/xml" MDTYPE="MODS">
                        <mets:xmlData>
                            <xsl:apply-templates select="value"/>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:dmdSec>
            </xsl:when>
            <xsl:when test="name='mets_section' and type='fileSec'">
                <xsl:apply-templates select="value"/>
            </xsl:when>
            <xsl:when test="name='mets_section' and type='structMap'">
                <xsl:apply-templates select="value"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="relations"/>

    <xsl:template match="stream_ref"/>

    <xsl:template match="value">
        <xsl:choose>
            <xsl:when
                test="contains(.,'&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;')">
                <xsl:value-of
                    select="substring-after(.,'&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;')"
                    disable-output-escaping="yes"/>
            </xsl:when>
            <xsl:when test="contains(.,'premis')">
                         <xsl:variable name="handle1">
                             <xsl:value-of select="substring-before(substring-after(.,'Value&gt;'),'&lt;')"
                        disable-output-escaping="yes"/>
                </xsl:variable>
                <handle>
                <xsl:value-of select="$handle1"/>
                </handle>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="." disable-output-escaping="yes"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="pid"/>
    <xsl:template match="control"/>
</xsl:stylesheet>
