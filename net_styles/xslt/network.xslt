<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:archimate="http://www.bolton.ac.uk/archimate"
	xmlns:canvas="http://namespaces.local/canvas"
	xmlns:report="http://magwas.rulez.org/my"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
<!--FIXME:
	xmlns:canvas="http://www.bolton.ac.uk/archimate/canvas"
-->

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="no"/>


	<xsl:param name="target"/>
	<xsl:param name="targetdir" />

	<xsl:template match="/">
      <objects>
        <xsl:variable name="doc" select="/"/>
		<xsl:variable name="nodes" select="//element[@xsi:type='archimate:Node' and ./property/@key='OS']"/>
        <xsl:for-each select="$nodes">
          <node>
            <xsl:copy-of select="@id|@name"/>
            <xsl:attribute name="OS" select="property[@key='OS']/@value"/>
            <xsl:variable name="id" select="@id"/>

		    <xsl:variable name="ifaces" select="//element[@xsi:type='archimate:AssociationRelationship' and (@source=$id or @target=$id)]"/>
            <xsl:for-each select="$ifaces[property/@key='nodeif']">
                <iface>
                    <xsl:attribute name="switchport" select="property[@key='switchport']/@value"/>
                    <xsl:attribute name="nodeif" select="property[@key='nodeif']/@value"/>
                    <xsl:attribute name="IP" select="property[@key='IP']/@value"/>
                    <xsl:attribute name="virtualip" select="property[@key='virtualip']/@value"/>
                    <xsl:attribute name="targetid" select=" if(@source=$id) then @target else @source"/>
                </iface>
            </xsl:for-each>

            <xsl:variable name="networks">
                <xsl:for-each select="$ifaces">
                    <xsl:variable name="source" select="@source"/>
                    <xsl:variable name="target" select="@target"/>
                    <xsl:copy-of select="//element[@xsi:type='archimate:Network' and (@id=$source or @id=$target)]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="$networks/*">
                <network>
                    <xsl:copy-of select="@id|@name"/>
                    <xsl:attribute name="IP" select="property[@key='IP']/@value"/>
                    <xsl:attribute name="maskbits" select="property[@key='maskbits']/@value"/>
                    <xsl:attribute name="gw" select="property[@key='gw']/@value"/>
                </network>
            </xsl:for-each>
          </node>
        </xsl:for-each>
      </objects>
	</xsl:template>

</xsl:stylesheet>


