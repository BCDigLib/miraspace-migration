<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="mods xlink" xmlns:marc="http://www.loc.gov/MARC21/slim">
	<!-- 
	Version 2.0 - 2012/05/11 WS  
	Upgraded stylesheet to XSLT 2.0 
	Upgraded to MODS 3.4
	MODS v3 to MARC21Slim transformation  	ntra 2/20/04 
-->
	<!--<xsl:include href="http://www.loc.gov/marcxml/xslt/MARC21slimUtils.xsl"/>-->
	<xsl:include href="MARC21slimUtils.xsl"/>
	<xsl:variable name="varFilenameLookup" select="document('pid-to-filename.xml')"/>

	<xsl:variable name="isHanvey">
		<xsl:choose>
			<xsl:when
				test="contains(mods:modsCollection/mods:mods[1]/mods:relatedItem/mods:titleInfo/mods:title, 'Bobbie')"
				>true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>

	</xsl:variable>
	<xsl:variable name="isBrooker">
		<xsl:choose>
			<xsl:when
				test="contains(mods:modsCollection/mods:mods[1]/mods:extension/localCollectionName, 'rooker')"
				>true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>

	</xsl:variable>
	<xsl:variable name="genreLookup" select="document('genreLookup.xml')"/>



	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>



	<xsl:template match="mods:modsCollection">
		<marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">

			<xsl:apply-templates/>
		</marc:collection>
	</xsl:template>

	<!-- 1/04 fix -->
	<!--<xsl:template match="mods:targetAudience/mods:listValue" mode="ctrl008">-->
	<xsl:template match="mods:targetAudience[@authority='marctarget']" mode="ctrl008">
		<xsl:text>|</xsl:text>
	</xsl:template>

	<xsl:template match="mods:typeOfResource" mode="leader">
		<xsl:choose>
			<xsl:when test="text()='text' and @manuscript='yes'">t</xsl:when>
			<xsl:when test="text()='text'">a</xsl:when>
			<xsl:when test="text()='cartographic' and @manuscript='yes'">f</xsl:when>
			<xsl:when test="text()='cartographic'">e</xsl:when>
			<xsl:when test="text()='notated music' and @manuscript='yes'">d</xsl:when>
			<xsl:when test="text()='notated music'">c</xsl:when>
			<!-- v3 musical/non -->
			<xsl:when test="text()='sound recording-nonmusical'">i</xsl:when>
			<xsl:when test="text()='sound recording'">j</xsl:when>
			<xsl:when test="text()='sound recording-musical'">j</xsl:when>
			<xsl:when test="text()='still image'">k</xsl:when>
			<xsl:when test="text()='moving image'">g</xsl:when>
			<xsl:when test="text()='three dimensional object'">r</xsl:when>
			<xsl:when test="text()='software, multimedia'">m</xsl:when>
			<xsl:when test="text()='mixed material'">p</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mods:typeOfResource" mode="ctrl008">
		<xsl:choose>
			<xsl:when test="text()='text' and @manuscript='yes'">BK</xsl:when>
			<xsl:when test="text()='text'">
				<xsl:choose>
					<xsl:when test="../mods:originInfo/mods:issuance='monographic'">BK</xsl:when>
					<xsl:when test="../mods:originInfo/mods:issuance='continuing'">SE</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="text()='cartographic' and @manuscript='yes'">MP</xsl:when>
			<xsl:when test="text()='cartographic'">MP</xsl:when>
			<xsl:when test="text()='notated music' and @manuscript='yes'">MU</xsl:when>
			<xsl:when test="text()='notated music'">MU</xsl:when>
			<xsl:when test="text()='sound recording'">MU</xsl:when>
			<!-- v3 musical/non -->
			<xsl:when test="text()='sound recording-nonmusical'">MU</xsl:when>
			<xsl:when test="text()='sound recording-musical'">MU</xsl:when>
			<xsl:when test="text()='still image'">VM</xsl:when>
			<xsl:when test="text()='still image' and @manuscript='yes'">VM</xsl:when>
			<xsl:when test="text()='moving image'">VM</xsl:when>
			<xsl:when test="text()='three dimensional object'">VM</xsl:when>
			<xsl:when test="text()='software, multimedia'">CF</xsl:when>
			<xsl:when test="text()='mixed material'">MM</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mods:typeOfResource">
		<xsl:choose>

			<xsl:when test="text()='still image'">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">336</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
						<marc:subfield code="b">
							<xsl:value-of select="substring(. , 1, 3)"/>
						</marc:subfield>
						<marc:subfield code="2">
							<xsl:text>rdacontent</xsl:text>
						</marc:subfield>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="text()='text'">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">336</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
						<marc:subfield code="b">
							<xsl:text>txt</xsl:text>
						</marc:subfield>
						<marc:subfield code="2">
							<xsl:text>rdacontent</xsl:text>
						</marc:subfield>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>



		</xsl:choose>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">337</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">computer</marc:subfield>
				<marc:subfield code="b">c</marc:subfield>
				<marc:subfield code="2">
					<xsl:text>rdamedia</xsl:text>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">338</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">online resource</marc:subfield>
				<marc:subfield code="b">cr</marc:subfield>
				<marc:subfield code="2">
					<xsl:text>rdacarrier</xsl:text>

				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>


		<!-- brute force addition of mods data missing from athletics records and leary and roche-->
		<xsl:if test="parent::mods:mods/mods:extension/mods:localCollectionName='MS1986043' or parent::mods:mods/mods:extension/mods:localCollectionName='MS1986041'">
			<xsl:call-template name="datafield">
			<xsl:with-param name="tag">655</xsl:with-param>
			<xsl:with-param name="ind2">7</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">Correspondence.</marc:subfield>
				<marc:subfield code="2">
					<xsl:text>lctgm</xsl:text>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">040</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">MChB-B</marc:subfield>
					<marc:subfield code="b">eng</marc:subfield>
					<marc:subfield code="c">MChB-B</marc:subfield>
					<marc:subfield code="e">dacs</marc:subfield>
					<marc:subfield code="e">rda</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
	</xsl:if>
		<xsl:if
			test="parent::mods:mods/mods:relatedItem/mods:identifier[@type='accession number']='BC.1986.019'">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">040</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">MChB-B</marc:subfield>
					<marc:subfield code="b">eng</marc:subfield>
					<marc:subfield code="c">MChB-B</marc:subfield>
					<marc:subfield code="e">dacs</marc:subfield>
					<marc:subfield code="e">rda</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">655</xsl:with-param>
				<xsl:with-param name="ind2">7</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">Photographs.</marc:subfield>
					<marc:subfield code="2">
						<xsl:text>gmgpc</xsl:text>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">533</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">Electronic reproduction.</marc:subfield>
					<marc:subfield code="b">Chestnut Hill, Mass. :</marc:subfield>
					<marc:subfield code="c">Boston College, </marc:subfield>
					<marc:subfield code="d">
						<xsl:value-of
							select="substring(parent::mods:mods/mods:physicalDescription/following-sibling::mods:extension/creation_date,1,4)"/>
						<xsl:text>. </xsl:text>
					</marc:subfield>

				</xsl:with-param>
			</xsl:call-template>

		</xsl:if>


	</xsl:template>

	<xsl:template name="controlField008-24-27">
		<xsl:variable name="chars">
			<xsl:for-each select="mods:genre[@authority='marc']">
				<xsl:choose>
					<xsl:when test=".='abstract of summary'">a</xsl:when>
					<xsl:when test=".='bibliography'">b</xsl:when>
					<xsl:when test=".='catalog'">c</xsl:when>
					<xsl:when test=".='dictionary'">d</xsl:when>
					<xsl:when test=".='directory'">r</xsl:when>
					<xsl:when test=".='discography'">k</xsl:when>
					<xsl:when test=".='encyclopedia'">e</xsl:when>
					<xsl:when test=".='filmography'">q</xsl:when>
					<xsl:when test=".='handbook'">f</xsl:when>
					<xsl:when test=".='index'">i</xsl:when>
					<xsl:when test=".='law report or digest'">w</xsl:when>
					<xsl:when test=".='legal article'">g</xsl:when>
					<xsl:when test=".='legal case and case notes'">v</xsl:when>
					<xsl:when test=".='legislation'">l</xsl:when>
					<xsl:when test=".='patent'">j</xsl:when>
					<xsl:when test=".='programmed text'">p</xsl:when>
					<xsl:when test=".='review'">o</xsl:when>
					<xsl:when test=".='statistics'">s</xsl:when>
					<xsl:when test=".='survey of literature'">n</xsl:when>
					<xsl:when test=".='technical report'">t</xsl:when>
					<xsl:when test=".='theses'">m</xsl:when>
					<xsl:when test=".='treaty'">z</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="makeSize">
			<xsl:with-param name="string" select="$chars"/>
			<xsl:with-param name="length" select="4"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="controlField008-30-31">
		<xsl:variable name="chars">
			<xsl:for-each select="mods:genre[@authority='marc']">
				<xsl:choose>
					<xsl:when test=".='biography'">b</xsl:when>
					<xsl:when test=".='conference publication'">c</xsl:when>
					<xsl:when test=".='drama'">d</xsl:when>
					<xsl:when test=".='essay'">e</xsl:when>
					<xsl:when test=".='fiction'">f</xsl:when>
					<xsl:when test=".='folktale'">o</xsl:when>
					<xsl:when test=".='history'">h</xsl:when>
					<xsl:when test=".='humor, satire'">k</xsl:when>
					<xsl:when test=".='instruction'">i</xsl:when>
					<xsl:when test=".='interview'">t</xsl:when>
					<xsl:when test=".='language instruction'">j</xsl:when>
					<xsl:when test=".='memoir'">m</xsl:when>
					<xsl:when test=".='rehersal'">r</xsl:when>
					<xsl:when test=".='reporting'">g</xsl:when>
					<xsl:when test=".='sound'">s</xsl:when>
					<xsl:when test=".='speech'">l</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="makeSize">
			<xsl:with-param name="string" select="$chars"/>
			<xsl:with-param name="length" select="2"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="makeSize">
		<xsl:param name="string"/>
		<xsl:param name="length"/>
		<xsl:variable name="nstring" select="normalize-space($string)"/>
		<xsl:variable name="nstringlength" select="string-length($nstring)"/>
		<xsl:choose>
			<xsl:when test="$nstringlength&gt;$length">
				<xsl:value-of select="substring($nstring,1,$length)"/>
			</xsl:when>
			<xsl:when test="$nstringlength&lt;$length">
				<xsl:value-of select="$nstring"/>
				<xsl:call-template name="buildSpaces">
					<xsl:with-param name="spaces" select="$length - $nstringlength"/>
					<xsl:with-param name="char">|</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$nstring"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mods:mods">


		<marc:record>
			<marc:leader>
				<!-- 00-04 -->
				<xsl:text>     </xsl:text>
				<!-- 05 -->
				<xsl:text>n</xsl:text>
				<!-- 06 -->
				<xsl:apply-templates mode="leader" select="mods:typeOfResource[1]"/>
				<!-- 07 -->

				<!--<xsl:when test="mods:originInfo/mods:issuance='monographic'">m</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance='continuing'">s</xsl:when>
					<xsl:when test="mods:typeOfResource/@collection='yes'">c</xsl:when>-->
				<!-- v3.4 Added mapping for single unit, serial, integrating resource, multipart monograph  -->
				<!--<xsl:when test="mods:originInfo/mods:issuance='multipart monograph'">m</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance='single unit'">m</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance='integrating resource'">i</xsl:when>
					<xsl:when test="mods:originInfo/mods:issuance='serial'">s</xsl:when>-->
				<xsl:text>d</xsl:text>
				<!--archival subunit-->
				<!-- 08 -->
				<!--Default will be archival control for BC custom -->
				<xsl:text>a</xsl:text>
				<!-- 09 -->
				<xsl:text> </xsl:text>
				<!-- 10 -->
				<xsl:text>2</xsl:text>
				<!-- 11 -->
				<xsl:text>2</xsl:text>
				<!-- 12-16 -->
				<xsl:text>     </xsl:text>
				<!-- 17 -->
				<xsl:text>7</xsl:text>
				<!-- 18 -->
				<xsl:text>i</xsl:text>
				<!-- 19 -->
				<xsl:text>#</xsl:text>
				<!-- 20-23 -->
				<xsl:text>4500</xsl:text>
			</marc:leader>
			<xsl:call-template name="controlRecordInfo"/>
			<xsl:if test="mods:genre[@authority='marc']='atlas'">
				<marc:controlfield tag="007">ad||||||</marc:controlfield>
			</xsl:if>
			<xsl:if test="mods:genre[@authority='marc']='model'">
				<marc:controlfield tag="007">aq||||||</marc:controlfield>
			</xsl:if>
			<xsl:if test="mods:genre[@authority='marc']='remote sensing image'">
				<marc:controlfield tag="007">ar||||||</marc:controlfield>
			</xsl:if>
			<xsl:if test="mods:genre[@authority='marc']='map'">
				<marc:controlfield tag="007">aj||||||</marc:controlfield>
			</xsl:if>
			<xsl:if test="mods:genre[@authority='marc']='globe'">
				<marc:controlfield tag="007">d|||||</marc:controlfield>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="mods:typeOfResource='text'">
					<marc:controlfield tag="006">m####|o##d########</marc:controlfield>
				</xsl:when>
				<xsl:when test="mods:typeOfResource='still image'">
					<marc:controlfield tag="006">m####|o##c########</marc:controlfield>
				</xsl:when>
				<xsl:when test="mods:typeOfResource='mixed material'">
					<marc:controlfield tag="006">m####|o##m########</marc:controlfield>
				</xsl:when>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="mods:physicalDescription/mods:digitalOrigin='born digital'">
					<marc:controlfield tag="007">cr#cz#||||||||</marc:controlfield>
				</xsl:when>
				<xsl:otherwise>
					<marc:controlfield tag="007">cr#cz#|||||a||</marc:controlfield>
				</xsl:otherwise>
			</xsl:choose>




			<marc:controlfield tag="008">
				<xsl:variable name="typeOf008">
					<xsl:apply-templates mode="ctrl008" select="mods:typeOfResource"/>
				</xsl:variable>
				<!-- 00-05 -->
				<xsl:choose>
					<!-- 1/04 fix -->
					<!--
					<xsl:when test="mods:recordInfo/mods:recordContentSource[@authority='marcorg']">
						<xsl:value-of select="mods:recordInfo/mods:recordCreationDate[@encoding='marc']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>      </xsl:text>
					</xsl:otherwise>-->
					<xsl:when test="mods:extension/creation_date">
						<xsl:value-of
							select="translate(substring(mods:extension/creation_date,3,8),'-','')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>      </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 06 -->
				<xsl:choose>
					<!--<xsl:when test="mods:originInfo/ms:issuance='monographic' and count(mods:originInfo/mods:dateIssued)=1">s</xsl:when>-->


					<xsl:when
						test="mods:originInfo/mods:issuance='monographic' and count(mods:originInfo/mods:dateCreated[@encoding='w3cdtf'])=1"
						>s</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:issuance='monographic' and count(mods:originInfo/mods:dateCreated[@encoding='w3cdtf'])=2"
						>m</xsl:when>
					<!-- v3 questionable -->
					<xsl:when test="mods:originInfo/mods:dateIssued[@qualifier='questionable']"
						>q</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:issuance='monographic' and mods:originInfo/mods:dateIssued[@point='start'] and mods:originInfo/mods:dateIssued[@point='end']"
						>m</xsl:when>
					<!--<xsl:when test="mods:originInfo/mods:issuance='monographic' and mods:originInfo/mods:dateCreated[@point='start'] and mods:originInfo/mods:Created[@point='end']">m</xsl:when>-->
					<xsl:when
						test="mods:originInfo/mods:issuance='continuing' and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']='9999'"
						>c</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:issuance='continuing' and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']='uuuu'"
						>u</xsl:when>
					<xsl:when
						test="mods:originInfo/mods:issuance='continuing' and mods:originInfo/mods:dateIssued[@point='end' and @encoding='marc']"
						>d</xsl:when>
					<xsl:when
						test="not(mods:originInfo/mods:issuance) and mods:originInfo/mods:dateIssued"
						>s</xsl:when>
					<!-- v3 copyright date-->
					<xsl:when test="mods:originInfo/mods:copyrightDate">s</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 07-14          -->
				<!-- 07-10 -->
				<xsl:choose>
					<xsl:when test="(not(string(mods:originInfo/mods:dateCreated[@keyDate='yes'][@encoding='w3cdtf']))) and $isBrooker='true'">
						
						
						<xsl:text>1716</xsl:text>
					</xsl:when>
					<xsl:when test="mods:originInfo/mods:dateCreated[@keyDate='yes']">
						<xsl:value-of
							select="substring(mods:originInfo/mods:dateCreated[@keyDate='yes'], 0, 5)"
						/>
					</xsl:when>

					<xsl:otherwise>
						<xsl:text>    </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 11-14 -->
				<xsl:choose>
					<xsl:when test="(not(string(mods:originInfo/mods:dateCreated[@keyDate='yes'][@encoding='w3cdtf']))) and $isBrooker='true'">
						
						
						<xsl:text>1930</xsl:text>
					</xsl:when>

					<xsl:when test="mods:originInfo/mods:dateCreated[@point='end']">
						<xsl:value-of
							select="substring(mods:originInfo/mods:dateCreated[@point='end'], 0, 5)"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>####</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 15-17 -->
				<xsl:choose>
					<!-- v3 place -->
					<xsl:when
						test="mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry']">
						<!-- v3 fixed marc:code reference and authority change-->
						<xsl:value-of
							select="mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry']"/>
						<!-- 1/04 fix -->
						<xsl:if
							test="string-length(mods:originInfo/mods:place/mods:placeTerm[@type='code'][@authority='marccountry'])=2">
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>mau</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 18-22 - MM -->
				<xsl:if test="$typeOf008='MM'">
					<xsl:text>#####</xsl:text>
				</xsl:if>
				<!-- 18-20 - VM -->
				<xsl:if test="$typeOf008='VM'">
					<xsl:text>nnn</xsl:text>
				</xsl:if>
				<!-- 18-21 - BK -->
				<xsl:if test="$typeOf008='BK'">

					<xsl:choose>
						<xsl:when
							test="mods:relatedItem/mods:part/mods:detail[1]/mods:title[text()='Anansi Stories']">

							<xsl:text>ag||</xsl:text>
						</xsl:when>
						<xsl:otherwise>||||</xsl:otherwise>
					</xsl:choose>
				</xsl:if>

				<!-- 21 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='SE'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marc']='database'">d</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='loose-leaf'">l</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='newspaper'">n</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='periodical'">p</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='series'">m</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='web site'">w</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='VM'">
						<xsl:text>#</xsl:text>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
				<!-- 22 -->
				<!-- 1/04 fix -->
				<xsl:if test="$typeOf008='BK' or $typeOf008='CF' or $typeOf008='MU' or $typeOf008='VM' ">
					
				<xsl:choose>
					<xsl:when test="mods:targetAudience[@authority='marctarget']">
						<xsl:apply-templates mode="ctrl008"
							select="mods:targetAudience[@authority='marctarget']"/>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>

				</xsl:choose>
				</xsl:if>
				<!-- 23 -->
				<xsl:choose>
					<xsl:when
						test="$typeOf008='BK' or $typeOf008='MU' or $typeOf008='SE' or $typeOf008='MM'"
						>o</xsl:when>

				</xsl:choose>
				<!-- 24-27 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='BK'">
						<xsl:call-template name="controlField008-24-27"/>
					</xsl:when>
					<xsl:when test="$typeOf008='MP'">
						<xsl:text>|</xsl:text>
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marc']='atlas'">e</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='globe'">d</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
						<xsl:text>||</xsl:text>
					</xsl:when>
					<xsl:when test="$typeOf008='CF'">
						<xsl:text>||</xsl:text>
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marc']='database'">e</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='font'">f</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='game'">g</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='numerical data'"
								>a</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='sound'">h</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
						<xsl:text>|</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>####</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 28 -->
				<xsl:text>#</xsl:text>
				<!-- 29 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='BK' or $typeOf008='SE'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marc']='conference publication'"
								>1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='MP' or $typeOf008='VM'">
						<xsl:choose>
							<xsl:when test="mods:physicalDescription/mods:form='braille'"
								>f</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form='electronic'"
								>o</xsl:when>
							<!-- o is more specific than s-->
							<xsl:when test="mods:physicalDescription/mods:form='microfiche'"
								>b</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form='microfilm'"
								>a</xsl:when>
							<xsl:when test="mods:physicalDescription/mods:form='print'">
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 30-31 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='MU'">
						<xsl:call-template name="controlField008-30-31"/>
					</xsl:when>
					<xsl:when test="$typeOf008='BK'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marc']='festschrift'"
								>1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
						<xsl:text>0</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>##</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 32 -->
				<xsl:text>#</xsl:text>
				<!-- 33 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='VM'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marc']='art originial'"
								>a</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='art reproduction'"
								>c</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='chart'">n</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='diorama'">d</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='filmstrip'">f</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='flash card'">o</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='graphic'">k</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='kit'">b</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='technical drawing'"
								>l</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='slide'">s</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='realia'">r</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='picture'">i</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='motion picture'"
								>m</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='model'">q</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='microscope slide'"
								>p</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='toy'">w</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='transparency'"
								>t</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='videorecording'"
								>v</xsl:when>
							<xsl:when test="mods:genre[@authority='gmgpc']='Prints'">c</xsl:when>
							<xsl:otherwise>i</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='BK'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marc']='comic strip'"
								>c</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='fiction'">1</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='essay'">e</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='drama'">d</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='humor, satire'"
								>h</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='letter'">i</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='novel'">f</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='short story'"
								>j</xsl:when>
							<xsl:when test="mods:genre[@authority='marc']='speech'">s</xsl:when>
							<xsl:when
								test="mods:relatedItem/mods:part/mods:detail[1]/mods:title[text()='Anansi Stories']"
								>j</xsl:when>
							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 34 -->
				<xsl:choose>
					<xsl:when test="$typeOf008='BK'">
						<xsl:choose>
							<xsl:when test="mods:genre[@authority='marc']='biography'">d</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="contains(mods:titleInfo[@usage='primary']/mods:title, 'Diary')"
								>d</xsl:when>


							<xsl:otherwise>|</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$typeOf008='VM'">
						<xsl:text>n</xsl:text>
					</xsl:when>
					<xsl:otherwise>|</xsl:otherwise>
				</xsl:choose>
				<!-- 35-37 -->
				<xsl:choose>
					<!-- v3 language -->
					<!-- BC Custom fixes LC bug, only language code, not text, should go to 008-->
					<!-- handle bad data in athletics-->
					<xsl:when
						test="mods:relatedItem[@*]/mods:identifier[@type='accession number']='BC.1986.019'">
						<xsl:text>zxx</xsl:text>
					</xsl:when>
					<xsl:when
						test="mods:language/mods:languageTerm[@type='code'][@authority='iso639-2b']">
						<xsl:value-of
							select="mods:language/mods:languageTerm[@type='code'][@authority='iso639-2b']"
						/>
					</xsl:when>

					<xsl:otherwise>
						<xsl:text>|||</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 38-39 -->
				<xsl:text>#d</xsl:text>

			</marc:controlfield>
			<!-- 1/04 fix sort -->
			<xsl:call-template name="source"/>
			<xsl:apply-templates/>
			<xsl:if test="mods:classification[@authority='lcc']">
				<xsl:call-template name="lcClassification"/>
			</xsl:if>
		<!--	<xsl:variable name="varFilenameLookup" select="document('pid-to-filename.xml')"/>-->
			<xsl:variable name="varPID">
				<xsl:choose>
					<xsl:when test="mods:extension/mods:localCollectionName='MS1986043'  or 'MS1986041'">
						<xsl:value-of select="mods:extension/hdl"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="mods:identifier[@type='local']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="lookThisUp" select="normalize-space(mods:genre[1])"/>
			<xsl:call-template name="datafield">

				<xsl:with-param name="tag">991</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">DAO</marc:subfield>
					<marc:subfield code="c">
						<xsl:value-of select="mods:extension/digital_surrogates"/>
					</marc:subfield>
					<marc:subfield code="l">
						<xsl:text>ead:c@LEVEL=</xsl:text>
						<xsl:choose>
							<xsl:when test="$isBrooker='true'">
								<xsl:text>item</xsl:text>
							</xsl:when>
							<xsl:when test="$isHanvey='true'">
								<xsl:text>file</xsl:text>
							</xsl:when>
							<xsl:when test="mods:extension/mods:localCollectionName='MS1986043' or 'MS1986041'">
								<xsl:text>item</xsl:text>
							</xsl:when>
							<xsl:when test="contains(mods:physicalDescription/mods:extent, 'item')">
								<xsl:text>item</xsl:text>
							</xsl:when>
							<xsl:when test="contains(mods:physicalDescription/mods:extent, 'file')">
								<xsl:text>file</xsl:text>
							</xsl:when>
						</xsl:choose>
					</marc:subfield>

					<marc:subfield code="t">
						<!--<xsl:value-of select="mods:extension/thumbnail"/>-->
						<xsl:choose>
							<xsl:when
								test="($isHanvey='true') or (mods:relatedItem/mods:identifier[@type='accession number']='BC.1986.019') 
								or mods:extension/mods:localCollectionName='MS2012004'">
								<xsl:value-of select="mods:extension/label"/>
							</xsl:when>
							<xsl:when test="($isBrooker='true')">
								<xsl:value-of
									select="$varFilenameLookup/dataroot/object[child::id=$varPID]/thumb"
								/>
							</xsl:when>
							<xsl:when test="mods:extension/mods:localCollectionName='MS1986043'  or 'MS1986041'">
								<xsl:value-of
									select="translate($varFilenameLookup/dataroot/object[child::id=$varPID]/thumb,'_','-')"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="mods:extension/label"/>
							</xsl:otherwise>
						</xsl:choose>

					</marc:subfield>
					<marc:subfield code="r">
						<xsl:choose>
							<xsl:when test="$isHanvey='true' or $isBrooker='true'">
								<xsl:text>PERL script executed on Excel sheet (</xsl:text>
								<xsl:value-of select="normalize-space(mods:extension/creation_date)"/>
								<xsl:text>)</xsl:text>
							</xsl:when>
							<xsl:when
								test="mods:relatedItem/mods:identifier[@type='accession number']='BC.1986.019' or 'MS1986043'">
								<xsl:text>Boston College/Archivists Toolkit Batch DAO</xsl:text>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="normalize-space(mods:extension/creation_date)"/>
								<xsl:text>)</xsl:text>
							</xsl:when>

							<xsl:otherwise>
								<xsl:value-of select="mods:recordInfo/mods:recordOrigin"/>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="normalize-space(mods:extension/creation_date)"/>
								<xsl:text>)</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</marc:subfield>
					<marc:subfield code="g">
						<xsl:choose>
							<xsl:when test="$isHanvey='true' or $isBrooker='true'">
								<xsl:value-of
									select="$genreLookup/genreLookup/genre[@value=$lookThisUp]/@term"
								/>
							</xsl:when>
							<xsl:when
								test="mods:relatedItem/mods:identifier[@type='accession number']='BC.1986.019'">
								<xsl:text>Photographs</xsl:text>
							</xsl:when>
							<xsl:when
								test="mods:extension/mods:localCollectionName='MS1986043'">
								<xsl:text>Correspondence</xsl:text>
							</xsl:when>
							<xsl:when
								test="mods:extension/mods:localCollectionName='MS1986041'">
								<xsl:text>Correspondence</xsl:text>
							</xsl:when>
							<xsl:when
								test="mods:extension/mods:localCollectionName='MS2012004'">
								<xsl:value-of select="mods:genre[@usage='primary']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="mods:genre[@displayLabel='general']"/>
							</xsl:otherwise>
						</xsl:choose>


					</marc:subfield>
					<marc:subfield code="2">
						<xsl:choose>
							<xsl:when test="$isHanvey='true' or $isBrooker='true'">
								<xsl:value-of
									select="$genreLookup/genreLookup/genre[@value=$lookThisUp]/@auth"
								/>
							</xsl:when>
							<xsl:when
								test="mods:relatedItem/mods:identifier[@type='accession number']='BC.1986.019'">
								<xsl:text>gmgpc</xsl:text>
							</xsl:when>
							<xsl:when
								test="mods:extension/mods:localCollectionName='MS1986043'">
								<xsl:text>lctgm</xsl:text>
							</xsl:when>
							<xsl:when
								test="mods:extension/mods:localCollectionName='MS1986041'">
								<xsl:text>lctgm</xsl:text>
							</xsl:when>
							<xsl:when
								test="mods:extension/mods:localCollectionName='MS2012004'">
								<xsl:value-of select="mods:genre[@usage='primary']/@authority"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="mods:genre/@authority"/>
							</xsl:otherwise>
						</xsl:choose>

					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>


		</marc:record>
	</xsl:template>

	<xsl:template match="*"/>

	<!-- Title Info elements -->
	<xsl:template match="mods:titleInfo[not(ancestor-or-self::mods:subject)][not(@type)][1]">

		<xsl:param name="ind1-245">
			<!-- determine if title main entry-->
			<xsl:choose>
				<xsl:when
					test="ancestor::mods:mods/descendant::mods:roleTerm[text()='pht' or text()='cre' or text()='aut' or text()='crp']/@type='code'">
					<xsl:text>1</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>0</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">245</xsl:with-param>
			<xsl:with-param name="ind1" select="$ind1-245"/>
			<xsl:with-param name="ind2" select="string-length(mods:nonSort)"/>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
				<!-- 1/04 fix -->
				<xsl:call-template name="stmtOfResponsibility"/>
				<xsl:call-template name="form"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:titleInfo[@type='abbreviated']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">210</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:titleInfo[@type='translated']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">242</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="ind2" select="string-length(mods:nonSort)"/>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:titleInfo[@type='alternative']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">246</xsl:with-param>
			<xsl:with-param name="ind1">3</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:titleInfo[@type='uniform'][1]">
		<xsl:choose>
			<!-- v3 role -->
			<xsl:when
				test="../mods:name/mods:role/mods:roleTerm[@type='text']='creator' or mods:name/mods:role/mods:roleTerm[@type='code']='cre'">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">240</xsl:with-param>
					<xsl:with-param name="ind1">1</xsl:with-param>
					<xsl:with-param name="ind2" select="string-length(mods:nonSort)"/>
					<xsl:with-param name="subfields">
						<xsl:call-template name="titleInfo"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">130</xsl:with-param>
					<xsl:with-param name="ind1" select="string-length(mods:nonSort)"/>
					<xsl:with-param name="subfields">
						<xsl:call-template name="titleInfo"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 1/04 fix: 2nd uniform title to 730 -->
	<xsl:template match="mods:titleInfo[@type='uniform'][position()>1]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">730</xsl:with-param>
			<xsl:with-param name="ind1" select="string-length(mods:nonSort)"/>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- 1/04 fix -->


	<xsl:template
		match="mods:titleInfo[not(ancestor-or-self::mods:subject)][not(@type)][position()>1]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">246</xsl:with-param>
			<xsl:with-param name="ind1">3</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="titleInfo"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Name elements -->
	<xsl:template match="mods:name">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">720</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart"/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>



		
	
	<!-- v3 role -->
	<xsl:template
		match="mods:name[@type='corporate'][mods:role/mods:roleTerm[@type='text']='creator']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">110</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart[1]"/>
				</marc:subfield>
				<xsl:for-each select="mods:namePart[position()>1]">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<marc:subfield code="4">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:description">
					<marc:subfield code="g">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3 role -->
	<xsl:template
		match="mods:name[@type='conference'][mods:role/mods:roleTerm[@type='text']='creator']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">111</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart[1]"/>
				</marc:subfield>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<marc:subfield code="4">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3 role -->
	<xsl:template match="mods:name[@type='personal']">
		
		<xsl:choose>
		<!--	<xsl:when test="self::node()[1] and ancestor::mods:mods/descendant::mods:roleTerm[text()='pht' or text()='cre' or text()='aut' or text()='crp']/@type='code'">-->
			<xsl:when test="self::node()[1] and self::node()/descendant::mods:roleTerm[text()='pht' or text()='cre' or text()='aut' or text()='crp']/@type='code'">	
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">100</xsl:with-param>
					<xsl:with-param name="ind1">1</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">
							<xsl:value-of select="mods:namePart[@type='family']"/>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="mods:namePart[@type='given'][1]"/>

							<xsl:choose>
								<xsl:when test="mods:namePart[@type='date'] or mods:namePart[@type='termsOfAddress']">
									<xsl:text>, </xsl:text>
								</xsl:when>
								<xsl:when test="mods:namePart[@type='given'][2]">
									<marc:subfield code="q">
										<xsl:text>(</xsl:text>
										<xsl:value-of select="mods:namePart[@type='given'][2]"/>
										<xsl:text>)</xsl:text>
									</marc:subfield>
								</xsl:when>
								<xsl:when test="mods:role">,</xsl:when>
								<xsl:otherwise>.</xsl:otherwise>
								
							</xsl:choose>
				
						</marc:subfield>
						
			
						
						
						
						<!-- v3 termsOfAddress -->
						<xsl:for-each select="mods:namePart[@type='termsOfAddress']">
							<marc:subfield code="c">
								<xsl:value-of select="."/>
								<xsl:if test="mods:namePart[@type='date'] or following-sibling::mods:role">
									<xsl:text>,</xsl:text>
								</xsl:if>
							</marc:subfield>
						</xsl:for-each>
						<xsl:for-each select="mods:namePart[@type='date']">
							<marc:subfield code="d">
								
								<xsl:value-of select="."/>
								<xsl:text>, </xsl:text>
							</marc:subfield>
						</xsl:for-each>
						<!-- v3 role -->
						<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
							<marc:subfield code="e">
								<xsl:value-of select="lower-case(.)"/>
								<xsl:text>.</xsl:text>
							</marc:subfield>
						</xsl:for-each>
						<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
							<marc:subfield code="4">
								<xsl:value-of select="."/>
							</marc:subfield>
						</xsl:for-each>
						<xsl:for-each select="mods:affiliation">
							<marc:subfield code="u">
								<xsl:value-of select="."/>
							</marc:subfield>
						</xsl:for-each>
						<xsl:for-each select="mods:description">
							<marc:subfield code="g">
								<xsl:value-of select="."/>
							</marc:subfield>
						</xsl:for-each>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		<xsl:otherwise>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">700</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart[@type='family']"/>
					<xsl:if test="mods:namePart[@type='family']and mods:namePart[@type='given']">, </xsl:if>
					<xsl:value-of select="mods:namePart[@type='given']"/>
					<xsl:choose>
						<xsl:when test="not(mods:namePart[@type='termsofAddress'] or mods:namePart[@type='date'] or mods:role)">.</xsl:when>
					<xsl:otherwise>,</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
				
				<xsl:for-each select="mods:namePart[@type='termsOfAddress']">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
						<xsl:text>,</xsl:text>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:namePart[@type='date']">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
						<xsl:text>,</xsl:text>
					</marc:subfield>
				</xsl:for-each>
				
				<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
					<marc:subfield code="e">
						<xsl:value-of select="lower-case(.)"/>
						<xsl:text>.</xsl:text>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<marc:subfield code="4">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:affiliation">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- v3 role -->
	<xsl:template
		match="mods:name[@type='corporate'][mods:role/mods:roleTerm[@type='text']!='creator' or not(mods:role)]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">710</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<!-- 1/04 fix -->
					<xsl:value-of select="mods:namePart[1]"/>
					<xsl:if test="count(mods:namePart)>1">
						<xsl:text>.</xsl:text>
					</xsl:if>
				</marc:subfield>
				<xsl:for-each select="mods:namePart[position()>1][not(last())]">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
					<xsl:text>.</xsl:text>
				</xsl:for-each>
				<xsl:for-each select="mods:namePart[last()]">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
						<xsl:if test="following-sibling::mods:role">
							<xsl:text>,</xsl:text>
						</xsl:if>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
					<marc:subfield code="e">
						<xsl:value-of select="lower-case(.)"/>
						<xsl:text>.</xsl:text>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<marc:subfield code="4">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:description">
					<marc:subfield code="g">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3 role -->
	<xsl:template
		match="mods:name[@type='conference'][mods:role/mods:roleTerm[@type='text']!='creator' or not(mods:role)]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">711</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="mods:namePart[1]"/>
				</marc:subfield>
				<!-- v3 role -->
				<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
					<marc:subfield code="4">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Genre elements -->
	<xsl:template
		match="mods:genre[@authority!='marcgt' and not(parent::mods:subject)]">
		<xsl:variable name="genreLookup" select="document('genreLookup.xml')"/>
		<xsl:variable name="lookThisUp" select="normalize-space(.)"/>
		<xsl:variable name="dfv">
			<xsl:choose>
				<xsl:when test="@authority = 'content' and @type='musical composition'"
					>047</xsl:when>
				<xsl:when test="@authority = 'content'">336</xsl:when>
				<xsl:otherwise>655</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">
				<xsl:value-of select="$dfv"/>
			</xsl:with-param>
			<xsl:with-param name="ind2">7</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of
						select="concat(translate(substring(. , 1, 1),
						'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
						substring(.,2,string-length(.)-1))"/>
					<xsl:text>.</xsl:text>
				</marc:subfield>


				<marc:subfield code="2">
					<xsl:value-of select="@authority"/>
				</marc:subfield>

			</xsl:with-param>
		</xsl:call-template>


		<xsl:if test="($isHanvey='true' and (.=parent::mods:mods/mods:genre[position()=last()])) or $isBrooker='true'">


			<xsl:call-template name="datafield">
				
				<xsl:with-param name="tag">655</xsl:with-param>

				<xsl:with-param name="ind2" select="7"/>
				<xsl:with-param name="subfields">

					<marc:subfield code="a">

								<xsl:value-of select="$genreLookup/genreLookup/genre[@value=$lookThisUp]/@term"/>
								<xsl:text>.</xsl:text>
					

					</marc:subfield>
					<xsl:for-each select="@authority">
						<marc:subfield code="2">
							<xsl:value-of
								select="$genreLookup/genreLookup/genre[@value=$lookThisUp]/@auth"/>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>

		</xsl:if>

	</xsl:template>


	<!-- Origin Info elements -->
	<xsl:template match="mods:originInfo">
		<!-- v3.4 Added for 264 ind2 = 0, 1, 2, 3-->
		<!-- v3 place, and fixed "mods:placeCode (v1?) -->
		<xsl:for-each select="mods:place/mods:placeTerm[@type='code'][@authority='iso3166']">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">044</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<!-- v3.4 -->
		<xsl:if test="mods:dateCaptured[@encoding='iso8601']">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">033</xsl:with-param>
				<xsl:with-param name="ind1">
					<xsl:choose>
						<xsl:when
							test="mods:dateCaptured[@point='start']|mods:dateCaptured[@point='end']"
							>2</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="ind2">0</xsl:with-param>
				<xsl:with-param name="subfields">
					<xsl:for-each select="mods:dateCaptured">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:choose>
			<xsl:when
				test="mods:issuance='monographic' and count(mods:dateCreated[@encoding='w3cdtf'])=1">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">046</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">
							<xsl:text>s</xsl:text>
						</marc:subfield>
						<marc:subfield code="k">
							<xsl:value-of
								select="translate(mods:dateCreated[@encoding='w3cdtf'],'-','')"/>
						</marc:subfield>

					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when
				test="mods:issuance='monographic' and count(mods:dateCreated[@encoding='w3cdtf'])=2">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">046</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">
							<xsl:text>m</xsl:text>
						</marc:subfield>
						<marc:subfield code="k">
							<xsl:value-of
								select="translate(mods:dateCreated[@encoding='w3cdtf'][1],'-','')"/>
						</marc:subfield>
						<marc:subfield code="l">
							<xsl:value-of
								select="translate(mods:dateCreated[@encoding='w3cdtf'][2],'-','')"/>
						</marc:subfield>

					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<!-- v3 dates -->
		<!--<xsl:if test="mods:dateModified|mods:dateCreated|mods:dateValid">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">046</xsl:with-param>
				<xsl:with-param name="subfields">					
					<xsl:for-each select="mods:dateModified">
						<marc:subfield code='j'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:dateCreated[@point='start']|mods:dateCreated[not(@point)]">
						<marc:subfield code='k'>
							<xsl:value-of select="."/>
						</marc:subfield>				
					</xsl:for-each>
					<xsl:for-each select="mods:dateCreated[@point='end']">
						<marc:subfield code='l'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:dateValid[@point='start']|mods:dateValid[not(@point)]">
						<marc:subfield code='m'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:dateValid[@point='end']">
						<marc:subfield code='n'>
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>			
			</xsl:call-template>	
		</xsl:if>	-->
		<xsl:for-each select="mods:edition">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">250</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="mods:frequency">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">310</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">
				<xsl:choose>
					<xsl:when
						test="@displayLabel='producer' or @displayLabel='publisher' 
						or @displayLabel='manufacturer' or @displayLabel='distributor'"
						>264</xsl:when>
					<xsl:otherwise>264</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<!--
			<xsl:with-param name="ind2">
				<xsl:choose>
					<xsl:when test="@displayLabel='producer'">0</xsl:when>
					<xsl:when test="@displayLabel='publisher'">1</xsl:when> 
					<xsl:when test="@displayLabel='manufacturer'">2</xsl:when>
					<xsl:when test="@displayLabel='distributor'">3</xsl:when>
				</xsl:choose>  
			</xsl:with-param>-->
			<!--BC Custom: Comment out param for indicator 2.  
									BC is not using @displayLabel and the output from the default 
									transform is creating an empty second indicator.  The need to 
									make this customization is a result of a problem with the original transform.-->
			<xsl:with-param name="subfields">
				<!-- v3 place; changed to text  -->
				<xsl:for-each select="mods:place/mods:placeTerm[@type='text']">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:publisher">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each
					select="mods:dateIssued[@point='start'] | mods:dateIssued[not(@point)]">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
						<!-- v3.4 generate question mark for dateIssued with qualifier="questionable" -->
						<xsl:if test="@qualifier='questionable'">?</xsl:if>
						<!-- v3.4 Generate a hyphen before end date -->
						<xsl:if test="mods:dateIssued[@point='end']"> - <xsl:value-of
								select="../mods:dateIssued[@point='end']"/>
						</xsl:if>
					</marc:subfield>
				</xsl:for-each>
				<xsl:choose>
					<xsl:when test="mods:dateOther">
						<marc:subfield code="c">
							<xsl:value-of select="mods:dateOther"/>
							<xsl:text>.</xsl:text>
						</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="mods:dateCreated[not(@*)]">
							<marc:subfield code="c">
								<xsl:value-of select="."/>
								<xsl:text>.</xsl:text>
							</marc:subfield>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>


			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Language -->
	<!-- v3.4 language with objectPart-->
	<xsl:template match="mods:language/mods:languageTerm[@objectPart]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">041</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:choose>
					<xsl:when test="@objectPart='text/sound track'">
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when
						test="@objectPart='summary or abstract' or @objectPart='summary' or @objectPart='abstract'">
						<marc:subfield code="b">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='sung or spoken text'">
						<marc:subfield code="d">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='librettos' or @objectPart='libretto'">
						<marc:subfield code="e">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="@objectPart='table of contents'">
						<marc:subfield code="f">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when
						test="@objectPart='accompanying material other than librettos' or @objectPart='accompanying material'">
						<marc:subfield code="g">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when
						test="@objectPart='original and/or intermediate translations of text' or @objectPart='translation'">
						<marc:subfield code="h">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when
						test="@objectPart='subtitles or captions' or @objectPart='subtitle or caption'">
						<marc:subfield code="j">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<marc:subfield code="a">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3 language -->
	<xsl:template match="mods:language/mods:languageTerm[@authority='iso639-2b']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">041</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3 language -->
	<xsl:template match="mods:language/mods:languageTerm[@authority='rfc3066']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">041</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="ind2">7</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<marc:subfield code="2">rfc3066</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3.4 language with scriptTerm -->
	<xsl:template match="mods:language/mods:languageTerm[@authority='rfc3066']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">546</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="b">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Physical Description -->
	<xsl:template match="mods:physicalDescription">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mods:extent[1]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">300</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:choose>
					<xsl:when test="not(contains(extent, 'file'))">
						<marc:subfield code="a">
							<xsl:text>1 online resource (</xsl:text>
							<xsl:value-of
								select="ancestor::mods:mods/mods:extension/digital_surrogates"/>
							<xsl:text> image</xsl:text>
							<xsl:if
								test="ancestor::mods:mods/mods:extension/digital_surrogates &gt; '1' "
								>s</xsl:if>
							<xsl:text>)</xsl:text>
						</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<marc:subfield code="a">
							<xsl:value-of
								select="replace(replace(replace(.,'file','online resource'), 'item','online resource'),'digital surrogate', 'image file')"
							/>
						</marc:subfield>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- add 533 note for digital origin-->
	<xsl:template match="mods:digitalOrigin">
		<xsl:choose>
			<xsl:when test=".='reformatted digital' or .='digitized other analog'">
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">533</xsl:with-param>
					<xsl:with-param name="subfields">
						<marc:subfield code="a">Electronic reproduction.</marc:subfield>
						<marc:subfield code="b">Chestnut Hill, Mass. :</marc:subfield>
						<marc:subfield code="c">Boston College, </marc:subfield>
						<marc:subfield code="d">
							<xsl:value-of
								select="substring(parent::mods:physicalDescription/following-sibling::mods:extension/creation_date,1,4)"/>
							<xsl:text>. </xsl:text>
						</marc:subfield>
						<xsl:if test="$isHanvey='true'">
							<marc:subfield code="n">
								<xsl:text>Digital reproduction of </xsl:text>
								<xsl:value-of
									select="parent::mods:physicalDescription/mods:extent[1]"/>
								<xsl:if test="parent::mods:physicalDescription/mods:extent[2]">
									<xsl:text> and </xsl:text>
									<xsl:value-of
										select="parent::mods:physicalDescription/mods:extent[2]"/>
								</xsl:if>
								<xsl:text>.</xsl:text>
							</marc:subfield>


						</xsl:if>
						<!--	
						<marc:subfield code='e'><xsl:value-of select="preceding-sibling::mods:extent"/>
						<xsl:text>.</xsl:text></marc:subfield>-->
					</xsl:with-param>
				</xsl:call-template>

			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<!-- v3.4 Added for 337 and 338 mods:form-->
	<xsl:template match="mods:form[not(@authority='gmd') and not(@authority='marcform')]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">
				<xsl:choose>
					<xsl:when test="@type='media'">337</xsl:when>
					<xsl:when test="@type='carrier'">338</xsl:when>
					<xsl:when test="@type='material'">340</xsl:when>
					<xsl:when test="@type='technique'">340</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:if test="not(@type='technique')">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:if>
				<xsl:if test="@type='technique'">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:if>
				<xsl:if test="@authority">
					<marc:subfield code="2">
						<xsl:value-of select="@authority"/>
					</marc:subfield>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Abstract -->
	<xsl:template match="mods:abstract">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">520</xsl:with-param>
			<xsl:with-param name="ind1">
				<!-- v3.4 added values for ind1 based on displayLabel -->
				<xsl:choose>
					<xsl:when test="@displayLabel='Subject'">0</xsl:when>
					<xsl:when test="@displayLabel='Review'">1</xsl:when>
					<xsl:when test="@displayLabel='Scope and content'">2</xsl:when>
					<xsl:when test="@displayLabel='Abstract'">2</xsl:when>
					<xsl:when test="@displayLabel='Content advice'">4</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<xsl:for-each select="@xlink:href">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Table of Contents -->
	<xsl:template match="mods:tableOfContents">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">505</xsl:with-param>
			<xsl:with-param name="ind1">
				<!-- v3.4 added values for ind1 based on displayLabel -->
				<xsl:choose>
					<xsl:when test="@displayLabel='Contents'">0</xsl:when>
					<xsl:when test="@displayLabel='Incomplete contents'">1</xsl:when>
					<xsl:when test="@displayLabel='Partial contents'">2</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<xsl:for-each select="@xlink:href">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Target Audience -->
	<!-- 1/04 fix -->
	<!--	<xsl:template match="mods:targetAudience">
		<xsl:apply-templates/>
	</xsl:template>-->

	<!--<xsl:template match="mods:targetAudience/mods:otherValue"> -->
	<xsl:template
		match="mods:targetAudience[not(@authority)] | mods:targetAudience[@authority!='marctarget']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">521</xsl:with-param>
			<xsl:with-param name="ind1">
				<!-- v3.4 added values for ind1 based on displayLabel -->
				<xsl:choose>
					<xsl:when test="@displayLabel='Reading grade level'">0</xsl:when>
					<xsl:when test="@displayLabel='Interest age level'">1</xsl:when>
					<xsl:when test="@displayLabel='Interest grade level'">2</xsl:when>
					<xsl:when test="@displayLabel='Special audience characteristics'">3</xsl:when>
					<xsl:when test="@displayLabel='Motivation or interest level'">3</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Note -->
	<!-- 1/04 fix -->
	<xsl:template
		match="mods:note[not(@type='statement of responsibility' or @type='reproduction')]">



		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">
				<xsl:choose>
					<xsl:when test="@type='performers'">511</xsl:when>
					<xsl:when test="@type='venue'">518</xsl:when>
					<xsl:when test="@type='original location'">535</xsl:when>
					<xsl:when test="@type='biographical/historical'">545</xsl:when>

					<xsl:otherwise>500</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:if test="@type='original location'">1</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:choose>
						<xsl:when test="contains(.,'Dimensions of Original')">
							<xsl:value-of select="concat(replace(.,'Original', 'original'),'.')"/>
						</xsl:when>
						<xsl:when test="contains(.,'BH') and $isHanvey='true'">
							<xsl:value-of select="concat(replace(.,'BH', 'bh'),'.')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
				<!-- 1/04 fix: 856$u instead -->
				<!--<xsl:for-each select="@xlink:href">
					<marc:subfield code='u'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>-->
			</xsl:with-param>
		</xsl:call-template>

		<xsl:for-each select="@xlink:href">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">856</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- 1/04 fix -->
	<!--<xsl:template match="mods:note[@type='statement of responsibility']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">245</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code='c'>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->
	<xsl:template match="mods:accessCondition">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">
				<xsl:choose>
					<xsl:when test="@type='restrictionOnAccess'">506</xsl:when>
					<xsl:when test="@type='useAndReproduction'">540</xsl:when>
					<xsl:when test="@type='use and reproduction'">540</xsl:when>
					<!-- BC Custom-->

				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:choose>
					<xsl:when test="$isHanvey='true'">
						<marc:subfield code="a">
							<xsl:text>The Bobbie Hanvey Photographic Archives are licensed under a Creative Commons Attribution-Noncommercial-No Derivative Works 3.0 United States License.</xsl:text>
						</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<marc:subfield code="a">
							<xsl:value-of select="normalize-space(.)"/>
						</marc:subfield>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- 1/04 fix -->
	<xsl:template name="controlRecordInfo">
		<!--<xsl:template match="mods:recordInfo">-->
		<xsl:for-each select="mods:extension/pid">
			<marc:controlfield tag="001">
				<xsl:value-of select="."/>
			</marc:controlfield>
			<marc:controlfield tag="003">DigiTool</marc:controlfield>

		</xsl:for-each>
		<xsl:for-each select="mods:recordInfo/mods:recordChangeDate[@encoding='iso8601']">
			<marc:controlfield tag="005">
				<xsl:value-of select="."/>
			</marc:controlfield>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="source">
		<xsl:for-each select="mods:recordInfo/mods:recordContentSource[@authority='marcorg']">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">040</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="mods:recordInfo/mods:recordContentSource[not(@authority)]">
			<xsl:choose>
				<xsl:when test="$isBrooker='true'"> 
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">040</xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a">MNcBCL</marc:subfield>
							<marc:subfield code="b">eng</marc:subfield>
							<marc:subfield code="c">MNcBCL</marc:subfield>
							<marc:subfield code="e">dacs</marc:subfield>
							<marc:subfield code="e">rda</marc:subfield>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">040</xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a">MChB-B</marc:subfield>
							<marc:subfield code="b">eng</marc:subfield>
							<marc:subfield code="c">MChB-B</marc:subfield>
							<marc:subfield code="e">dacs</marc:subfield>
							<marc:subfield code="e">rda</marc:subfield>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>



	<!-- v3 authority -->

	<xsl:template match="mods:subject">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mods:subject[local-name(*[1])='topic' or local-name(*[1])='occupation']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">650</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:for-each select="node()">
					<xsl:choose>
						<xsl:when test="local-name()='geographic'">
							<marc:subfield code="z">
								<xsl:value-of select="."/>
								<xsl:if test="position()=last()">
									<xsl:text>.</xsl:text>
								</xsl:if>
							</marc:subfield>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="local-name()='genre'">
							<marc:subfield code="v">
								<xsl:value-of select="."/>
								<xsl:if test="position()=last()">
									<xsl:text>.</xsl:text>
								</xsl:if>

							</marc:subfield>
						</xsl:when>
						<xsl:when test="local-name()='temporal'">
							<marc:subfield code="y">
								<xsl:value-of select="."/>
								<xsl:if test="position()=last()">
									<xsl:text>.</xsl:text>
								</xsl:if>
							</marc:subfield>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>


			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:subject[local-name(*[1])='titleInfo']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">630</xsl:with-param>
			<xsl:with-param name="ind1">
				<xsl:value-of select="string-length(mods:titleInfo/mods:nonSort)"/>
			</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:call-template name="authorityInd"/>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:for-each select="mods:titleInfo">
					<xsl:call-template name="titleInfo"/>
				</xsl:for-each>
				<xsl:apply-templates select="*[position()>1]"/>
			</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

	<xsl:template match="mods:subject[local-name(*[1])='name']">
		<xsl:for-each select="*[1]">
			<xsl:choose>
				<xsl:when test="@type='personal'">
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">600</xsl:with-param>

						<xsl:with-param name="ind1">
							<xsl:choose>
								<xsl:when test="mods:namePart[@type='family']">1</xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>

						</xsl:with-param>
						<xsl:with-param name="ind2">0</xsl:with-param>
						<xsl:with-param name="subfields">

							<marc:subfield code="a">
								<xsl:choose>
									<xsl:when test="mods:namePart[@type='family']">
										<xsl:value-of select="mods:namePart[@type='family']"/>
										<xsl:text>, </xsl:text>
										<xsl:value-of select="mods:namePart[@type='given'][1]"/>
										<xsl:if
											test="(mods:namePart[@type='date']) or (mods:namePart[@type='termsOfAddress'])">
											<xsl:text>, </xsl:text>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>

										<xsl:value-of select="mods:namePart[@type='given'][1]"/>
										<xsl:if
											test="(mods:namePart[@type='date'] or  mods:namePart[@type='terms of address']) and not(mods:namePart[@type='given'][2])">
											<xsl:text>,</xsl:text>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</marc:subfield>
							<xsl:if test="mods:namePart[@type='given'][2]">
								<marc:subfield code="q">
									<xsl:text>(</xsl:text>
									<xsl:value-of select="mods:namePart[@type='given'][2]"/>
									<xsl:text>)</xsl:text>
								</marc:subfield>
							</xsl:if>
							<!-- v3 termsofAddress -->
							<xsl:for-each select="mods:namePart[@type='termsOfAddress']">
								<marc:subfield code="c">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<xsl:for-each select="mods:namePart[@type='date']">
								<!-- v3 namepart/date was $a; fixed to $d -->
								<marc:subfield code="d">

									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<!-- v3 role -->
							<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
								<marc:subfield code="e">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<xsl:for-each select="mods:affiliation">
								<marc:subfield code="u">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<xsl:for-each select="following-sibling::node()">
								<xsl:choose>
									<xsl:when test="local-name()='genre'">
										<marc:subfield code="v">
											<xsl:value-of select="."/>

											<xsl:text>.</xsl:text>

										</marc:subfield>
									</xsl:when>
									<xsl:when test="local-name()='topic'">
										<marc:subfield code="x">
											<xsl:value-of select="."/>
										</marc:subfield>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
							<xsl:apply-templates select="*[position()>1]"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="@type='corporate'">
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">610</xsl:with-param>
						<xsl:with-param name="ind1">2</xsl:with-param>
						<xsl:with-param name="ind2">0</xsl:with-param>
						<xsl:with-param name="subfields">
							<marc:subfield code="a">
								<xsl:value-of select="mods:namePart[1]"/>
								<xsl:if test="not(position()=last())">
									<xsl:text>. </xsl:text>
								</xsl:if>
							</marc:subfield>
							<xsl:for-each select="mods:namePart[position()>1]">
								<marc:subfield code="b">
									<xsl:value-of select="."/>
									<xsl:if test="not(position()=last())">
										<xsl:text>. </xsl:text>
									</xsl:if>



								</marc:subfield>
							</xsl:for-each>
							<!-- v3 role -->
							<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
								<marc:subfield code="e">
									<xsl:value-of select="."/>
								</marc:subfield>
							</xsl:for-each>
							<xsl:for-each select="following-sibling::node()">
								<xsl:choose>
									<xsl:when test="local-name()='genre'">
										<marc:subfield code="v">
											<xsl:value-of select="."/>
											<xsl:text>.</xsl:text>
										</marc:subfield>
									</xsl:when>
									<xsl:when test="local-name()='temporal'">
										<marc:subfield code="y">
											<xsl:value-of select="."/>
										</marc:subfield>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="@type='conference'">
					<xsl:call-template name="datafield">
						<xsl:with-param name="tag">611</xsl:with-param>
						<xsl:with-param name="ind1">2</xsl:with-param>
						<xsl:with-param name="ind2">0</xsl:with-param>

						<xsl:with-param name="subfields">
							<xsl:choose>
								<xsl:when test="$isHanvey='true'">
									<marc:subfield code="a">
										<xsl:text>International Eucharistic Congress</xsl:text>
									</marc:subfield>
									<marc:subfield code="n">
										<xsl:text>(50th :</xsl:text>
									</marc:subfield>
									<marc:subfield code="d">
										<xsl:text>2012 :</xsl:text>
									</marc:subfield>
									<marc:subfield code="c">
										<xsl:text>Dublin, Ireland)</xsl:text>
									</marc:subfield>




								</xsl:when>
								<xsl:otherwise>

									<marc:subfield code="a">
										<xsl:value-of select="mods:namePart"/>
									</marc:subfield>
									<!-- v3 role -->
									<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
										<marc:subfield code="4">
											<xsl:value-of select="."/>
										</marc:subfield>
									</xsl:for-each>
									<xsl:apply-templates select="*[position()>1]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mods:subject[local-name(*[1])='geographic']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">651</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:call-template name="authorityInd"/>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:for-each select="node()">
					<xsl:choose>
						<xsl:when test="local-name()='genre'">
							<marc:subfield code="v">
								<xsl:value-of select="."/>
								<xsl:if test="position()=last()">
									<xsl:text>.</xsl:text>
								</xsl:if>
							</marc:subfield>
						</xsl:when>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="local-name()='temporal'">
							<marc:subfield code="y">
								<xsl:value-of select="."/>
								<xsl:if test="position()=last()">
									<xsl:text>.</xsl:text>
								</xsl:if>
							</marc:subfield>
						</xsl:when>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="local-name()='topic'">
							<marc:subfield code="x">
								<xsl:value-of select="."/>
								<xsl:if test="position()=last()">
									<xsl:text>.</xsl:text>
								</xsl:if>
							</marc:subfield>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>


			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:subject[local-name(*[1])='temporal']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">650</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="*[1]"/>
				</marc:subfield>
				<xsl:apply-templates select="*[position()>1]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- v3 geographicCode -->
	<xsl:template match="mods:subject/mods:geographicCode[@authority]">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">043</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:for-each select="self::mods:geographicCode[@authority='marcgac']">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="self::mods:geographicCode[@authority='iso3166']">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- 1/04 fix was 630 -->
	<xsl:template match="mods:subject[@* or not(@*)]/mods:hierarchicalGeographic">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">752</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:for-each select="mods:continent">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:country">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:state">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:province">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
						<xsl:if test="not(following::sibling/mods:city)">.</xsl:if>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:county">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
						<xsl:if test="not(mods:city)">.</xsl:if>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:city">
					<marc:subfield code="d">
						<xsl:value-of select="."/>
						<xsl:if test="not(mods:citySection)">.</xsl:if>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:citySection">
					<marc:subfield code="f">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:region">
					<marc:subfield code="g">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:if test="ancestor::mods:subject[@valueURI]">
					<marc:subfield code="1">
						<xsl:value-of select="ancestor::mods:subject/@valueURI"/>
					</marc:subfield>
				</xsl:if>
				<xsl:if test="ancestor::mods:subject[@authority='tgn']">
					<marc:subfield code="2">
						<xsl:text>tgn</xsl:text>
					</marc:subfield>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:subject/mods:cartographics">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">255</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:for-each select="mods:coordinates">
					<marc:subfield code="c">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:scale">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<xsl:for-each select="mods:projection">
					<marc:subfield code="b">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- checked with Meg, move occupation to topic 20180508 -->
	<!--	<xsl:template match="mods:subject/mods:occupation">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">656</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template> -->

	<xsl:template match="mods:subject/mods:topic">
		<marc:subfield code="x">
			<xsl:value-of select="."/>
			<xsl:if test=" position()=last()">
				<xsl:text>.</xsl:text>
			</xsl:if>
		</marc:subfield>
	</xsl:template>

	<xsl:template match="mods:subject/mods:temporal">
		<marc:subfield code="y">
			<xsl:value-of select="."/>
			<xsl:if test=" position()=last()">
				<xsl:text>.</xsl:text>
			</xsl:if>
		</marc:subfield>
	</xsl:template>

	<xsl:template match="mods:subject/mods:geographic">
		<marc:subfield code="z">
			<xsl:value-of select="."/>
			<xsl:if test=" position()=last()">
				<xsl:text>.</xsl:text>
			</xsl:if>
		</marc:subfield>
	</xsl:template>

	<xsl:template name="titleInfo">
		<xsl:for-each select="mods:title">
			<marc:subfield code="a">
				<xsl:value-of select="../mods:nonSort"/>
				<xsl:value-of select="normalize-space(.)"/>
				<xsl:text>.</xsl:text>
			</marc:subfield>
		</xsl:for-each>
		<!-- 1/04 fix -->
		<xsl:for-each select="mods:subTitle">
			<marc:subfield code="b">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:partNumber">
			<marc:subfield code="n">
				<xsl:value-of select="."/>
				<xsl:if test="$isBrooker">.</xsl:if>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:partName">
			<marc:subfield code="p">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="stmtOfResponsibility">
		<xsl:for-each select="following-sibling::mods:note[@type='statement of responsibility']">
			<marc:subfield code="c">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
	</xsl:template>

	<!-- Classification -->

	<!--<xsl:template match="mods:classification[@authority='lcc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">050</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:choose>
				<xsl:when test="../mods:recordInfo/mods:recordContentSource='DLC' or ../mods:recordInfo/mods:recordContentSource='Library of Congress'">0</xsl:when>
				<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->

	<xsl:template match="mods:classification[@authority='ddc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">082</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<xsl:for-each select="@edition">
					<marc:subfield code="2">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:classification[@authority='udc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">080</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:classification[@authority='nlm']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">060</xsl:with-param>
			<xsl:with-param name="ind2">4</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:classification[@authority='sudocs']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">086</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:classification[@authority='candocs']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">086</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3.4 -->
	<xsl:template match="mods:classification[@authority='content']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">084</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="lcClassification">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">050</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:choose>
					<xsl:when
						test="../mods:recordInfo/mods:recordContentSource='DLC' or ../mods:recordInfo/mods:recordContentSource='Library of Congress'"
						>0</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:for-each select="mods:classification[@authority='lcc']">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Identifiers -->
	<!-- v3.4 updated doi subfields and datafield mapping -->
	<xsl:template match="mods:identifier[@type='doi'] | mods:identifier[@type='hdl'] ">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
				<marc:subfield code="2">
					<xsl:value-of select="@type"/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>




	<xsl:template match="mods:identifier[@type='isbn']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">020</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='isrc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='ismn']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='issn'] | mods:identifier[@type='issn-l'] ">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">022</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='issue number']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='lccn']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">010</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:identifier[@type='local']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">035</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:if test="$isBrooker">(Brooker)</xsl:if>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:identifier[@type='matrix number']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='music publisher']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">3</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='music plate']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">2</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='sici']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield>
					<!-- v3.4 updated code to handle invalid isbn -->
					<xsl:attribute name="code">
						<xsl:choose>
							<xsl:when test="@invalid='yes'">z</xsl:when>
							<xsl:otherwise>a</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- v3.4 -->
	<xsl:template match="mods:identifier[@type='stocknumber']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">037</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="mods:identifier[@type='uri']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:text> </xsl:text>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="u">
					<xsl:value-of select="."/>
				</marc:subfield>

			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--v3 location/url -->
	<xsl:template match="mods:location[mods:url]">
		<xsl:for-each select="mods:url[not(@access='object in context')]">
			<!--Skip link to BCLSCO-->
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">856</xsl:with-param>
				<xsl:with-param name="ind1">4</xsl:with-param>
				<!--BC Custom; we'll always be using 4 for http!-->
				<xsl:with-param name="ind2">
					<xsl:if test="@access='raw object'">0</xsl:if>
					<!-- BC Custom varies 2nd indicator 2 -->
					<xsl:if test="@access='preview'">1</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="3">
						<xsl:if test="@access='raw object'">Digital Version</xsl:if>
						<!-- BC Custom various 2nd indicator 2 -->
						<xsl:if test="@access='preview'">Thumbnail</xsl:if>
					</marc:subfield>

					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<xsl:template match="mods:identifier[@type='videorecording']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">028</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="authorityInd">
		<xsl:choose>
			<xsl:when test="@authority='lcsh'">0</xsl:when>
			<xsl:when test="@authority='lcshac'">1</xsl:when>
			<xsl:when test="@authority='mesh'">2</xsl:when>
			<xsl:when test="@authority='csh'">3</xsl:when>
			<xsl:when test="@authority='nal'">5</xsl:when>
			<xsl:when test="@authority='rvm'">6</xsl:when>
			<xsl:when test="@authority">7</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
			<!-- v3 blank ind2 fix-->
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mods:relatedItem/mods:identifier[@type='uri']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind2">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="u">
					<xsl:value-of select="."/>
				</marc:subfield>

			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- v3 physicalLocation -->
	<!--Custom BC : comment out physical location
	<xsl:template match="mods:location[mods:physicalLocation]">
		<xsl:for-each select="mods:physicalLocation">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">852</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="."/>
					</marc:subfield>-->
	<!-- v3 displayLabel -->
	<!--
					<xsl:for-each select="@displayLabel">
						<marc:subfield code="3">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>		
		</xsl:for-each>
	</xsl:template>-->

	<!-- v3.4 add physical location url -->
	<!--BC custom comment out
	<xsl:template match="mods:location[mods:physicalLocation[@xlink]]">
		<xsl:for-each select="mods:physicalLocation">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">852</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="u">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>		
		</xsl:for-each>
	</xsl:template>-->
	<!-- v3.4 location url -->
	<xsl:template match="mods:location[mods:uri]">
		<xsl:for-each select="mods:uri">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">852</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield>
						<xsl:choose>
							<xsl:when test="@displayLabel='content'">3</xsl:when>
							<xsl:when test="@dateLastAccessed='content'">z</xsl:when>
							<xsl:when test="@note='contents of subfield'">z</xsl:when>
							<xsl:when test="@access='preview'">3</xsl:when>
							<xsl:when test="@access='raw object'">3</xsl:when>
							<xsl:when test="@access='object in context'">3</xsl:when>
							<xsl:when test="@access='primary display'">z</xsl:when>
						</xsl:choose>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mods:extension">

		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">940</xsl:with-param>
			<!-- BC Custom.  mods extension maps to 940 rather than 887-->
			<xsl:with-param name="ind1">1</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:choose>
					<xsl:when test="$isHanvey='true'">
						<marc:subfield code="a">
							<xsl:text>ms2001039</xsl:text>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="mods:localCollectionName">
						<marc:subfield code="a">
							<xsl:value-of select="mods:localCollectionName"/>
						</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<marc:subfield code="a">
							<xsl:value-of select="localCollectionName"/>
						</marc:subfield>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>

		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">024</xsl:with-param>
			<xsl:with-param name="ind1">7</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:choose>
					<xsl:when test="contains(hdl,'http')">
						<marc:subfield code="a">
							<xsl:value-of select="substring-after(hdl, 'http://hdl.handle.net/')"/>
						</marc:subfield>
					</xsl:when>
					<xsl:otherwise>
						<marc:subfield code="a">
							<xsl:value-of select="hdl"/>
						</marc:subfield>
					</xsl:otherwise>
				</xsl:choose>

				<marc:subfield code="2">hdl</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>


		<!--	<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param>
			<xsl:with-param name="ind2">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="x">THUMBNAIL</marc:subfield>
				<marc:subfield code="u">
					<xsl:value-of select="concat('http://scenery.bc.edu/',substring-after(hdl, '/'),'_001.jp2/full/!200,200/0/default.jpg')"/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>	-->

		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="3">
					<xsl:value-of select="digital_surrogates"/>
					<xsl:text> image</xsl:text>
					<xsl:if test="digital_surrogates &gt; '1'">
						<xsl:text>s</xsl:text>
					</xsl:if>
					<!--<xsl:value-of select="replace(replace(replace(..//mods:physicalDescription/mods:extent,'1 file \(',''), '1 item ',''),'digital surrogate', 'image')"/>-->
				</marc:subfield>
				<!--	<marc:subfield code="u">
					<xsl:text>https://library.bc.edu/iiif/view/</xsl:text>
					<xsl:value-of select="substring-after(hdl, '/')"/>
					<xsl:text>.html</xsl:text>
				</marc:subfield>-->
				<!--	<xsl:variable name="varFilenameLookup" select="document('pid-to-filename.xml')"/>
				<xsl:variable name="varPID">
					<xsl:value-of select="thumbnail"/>
				</xsl:variable>-->
				<marc:subfield code="u">
					<xsl:text>https://library.bc.edu/iiif/view/</xsl:text>
					<xsl:choose>
						<xsl:when test="contains(hdl,'http')">
							<xsl:value-of
								select="substring-after(hdl, 'http://hdl.handle.net/2345.2/')"/>
						</xsl:when>
						<xsl:when test="$isHanvey='true'">
							<xsl:text>MS2001_039_</xsl:text>
							<xsl:value-of select="substring-after(hdl, '/')"/>
						</xsl:when>
						<xsl:when test="$isBrooker='true'">
							<xsl:text>brooker_</xsl:text>
							<xsl:value-of select="parent::mods:mods/mods:identifier[@type='local']"
							/>
						</xsl:when>
						<xsl:when test="parent::mods:mods/mods:extension/mods:localCollectionName='MS1986043'">
							<xsl:text>MS1986_043_</xsl:text>
							<xsl:variable name="varPID">
								<xsl:value-of select="parent::mods:mods/mods:extension/hdl"></xsl:value-of>
							</xsl:variable>	
							<xsl:value-of
								select="substring($varFilenameLookup/dataroot/object[child::id=$varPID]/thumb,12,7)"
							/>


							
						</xsl:when>
						<xsl:when test="parent::mods:mods/mods:extension/mods:localCollectionName='MS1986041'">
							<xsl:text>MS1986_041_</xsl:text>
							<xsl:variable name="varPID">
								<xsl:value-of select="parent::mods:mods/mods:extension/hdl"></xsl:value-of>
							</xsl:variable>	
							<xsl:value-of
								select="substring($varFilenameLookup/dataroot/object[child::id=$varPID]/thumb,12,5)"
							/>
					</xsl:when>
						<xsl:when test="parent::mods:mods/mods:extension/mods:localCollectionName='MS2012004'">
							
							<xsl:value-of select="substring(label,1,string-length(label)-4)"> </xsl:value-of>							
						</xsl:when>
						<xsl:otherwise>


							<xsl:value-of select="substring-after(hdl, '/')"/>
						</xsl:otherwise>
					</xsl:choose>


				</marc:subfield>


				<marc:subfield code="q">
					<xsl:choose>
						<xsl:when
							test="contains(../mods:physicalDescription/mods:internetMediaType[1], ',')">
							<xsl:value-of
								select="substring-before(../mods:physicalDescription/mods:internetMediaType[1], ',')"
							/>
						</xsl:when>
						<xsl:when test="$isHanvey='true'">
							<xsl:text>image/tiff</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="../mods:physicalDescription/mods:internetMediaType[position()=last()]"
							/>
						</xsl:otherwise>
					</xsl:choose>
				</marc:subfield>
				<marc:subfield code="z">
					<xsl:text>View online resource (</xsl:text>
					<xsl:value-of select="digital_surrogates"/>
					<xsl:text> image</xsl:text>
					<xsl:if test="digital_surrogates &gt; '1'">
						<xsl:text>s</xsl:text>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</marc:subfield>

			</xsl:with-param>
		</xsl:call-template>


	</xsl:template>
	<!-- 1/04 fix -->
	<!--<xsl:template match="mods:internetMediaType">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind2">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="q">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>		
	</xsl:template>	-->



	<xsl:template name="form">
		<xsl:if test="../mods:physicalDescription/mods:form[@authority='gmd']">
			<marc:subfield code="h">
				<xsl:value-of select="../mods:physicalDescription/mods:form[@authority='gmd']"/>
			</marc:subfield>
		</xsl:if>
	</xsl:template>

	<!-- v3 isReferencedBy -->
	<xsl:template match="mods:relatedItem[@type='isReferencedBy']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">510</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:variable name="noteString">
					<xsl:for-each select="*">
						<xsl:value-of select="concat(.,', ')"/>
					</xsl:for-each>
				</xsl:variable>
				<marc:subfield code="a">
					<xsl:value-of select="substring($noteString, 1,string-length($noteString)-2)"/>
				</marc:subfield>
				<!--<xsl:call-template name="relatedItem76X-78X"/>-->
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='series']">
		<!-- v3 build series type -->
		<xsl:for-each select="mods:titleInfo">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">440</xsl:with-param>
				<xsl:with-param name="subfields">
					<xsl:call-template name="titleInfo"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="mods:name">
			<xsl:call-template name="datafield">
				<xsl:with-param name="tag">
					<xsl:choose>
						<xsl:when test="@type='personal'">800</xsl:when>
						<xsl:when test="@type='corporate'">810</xsl:when>
						<xsl:when test="@type='conference'">811</xsl:when>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="subfields">
					<marc:subfield code="a">
						<xsl:value-of select="mods:namePart"/>
					</marc:subfield>
					<xsl:if test="@type='corporate'">
						<xsl:for-each select="mods:namePart[position()>1]">
							<marc:subfield code="b">
								<xsl:value-of select="."/>
							</marc:subfield>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="@type='personal'">
						<xsl:for-each select="mods:namePart[@type='termsOfAddress']">
							<marc:subfield code="c">
								<xsl:value-of select="."/>
							</marc:subfield>
						</xsl:for-each>
						<xsl:for-each select="mods:namePart[@type='date']">
							<!-- v3 namepart/date was $a; fixed to $d -->
							<marc:subfield code="d">
								<xsl:value-of select="."/>
							</marc:subfield>
						</xsl:for-each>
					</xsl:if>
					<!-- v3 role -->
					<xsl:if test="@type!='conference'">
						<xsl:for-each select="mods:role/mods:roleTerm[@type='text']">
							<marc:subfield code="e">
								<xsl:value-of select="."/>
							</marc:subfield>
						</xsl:for-each>
					</xsl:if>
					<xsl:for-each select="mods:role/mods:roleTerm[@type='code']">
						<marc:subfield code="4">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mods:relatedItem[not(@type)]">
		<!-- v3 was type="related" -->
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">787</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='preceding']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">780</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='succeeding']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">785</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="ind2">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='otherVersion']">

				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">775</xsl:with-param>
					<xsl:with-param name="subfields">
						<xsl:call-template name="relatedItem76X-78X"/>
					</xsl:with-param>
				</xsl:call-template>

	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='otherFormat']">
		
	<xsl:choose>
		<xsl:when test="ancestor::mods:mods/mods:extension/mods:localCollectionName='MS1986043'  or 'MS1986041'"/>
			<xsl:otherwise>
				<xsl:call-template name="datafield">
					<xsl:with-param name="tag">776</xsl:with-param>
					<xsl:with-param name="subfields">
						<xsl:call-template name="relatedItem76X-78X"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='original']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">534</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='host']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">773</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<!-- v3 displaylabel -->
				<xsl:for-each select="@displaylabel">
					<marc:subfield code="3">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
				<!-- v3 part/text -->

	
						<xsl:for-each select="mods:part/mods:text">
						<marc:subfield code="g">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>

				<!-- v3 sici part/detail 773$q 	1:2:3<4-->
				<!--	<xsl:if test="mods:part/mods:detail">
					<xsl:variable name="parts">				
						<xsl:for-each select="mods:part/mods:detail">
							<xsl:value-of select="concat(mods:number,':')"/>
						</xsl:for-each>
					</xsl:variable>					
					<marc:subfield code="q">						
						<xsl:value-of select="concat(substring($parts,1,string-length($parts)-1),'&lt;',mods:part/mods:extent/mods:start)"/>
					</marc:subfield>
				</xsl:if>-->
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind1">4</xsl:with-param>
			<xsl:with-param name="ind2">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="3">
					<xsl:text>About the </xsl:text>
					<xsl:value-of select="mods:titleInfo/mods:title"/>


				</marc:subfield>
				<xsl:choose>
					<xsl:when
						test="following-sibling::mods:extension/localCollectionName='BC1988027'">
						<marc:subfield code="u"
							>http://hdl.handle.net/2345.2/BC1988-027</marc:subfield>
					</xsl:when>
					<xsl:when test="$isHanvey='true'">
						<marc:subfield code="u"
							>http://www.bc.edu/sites/libraries/hanvey/index.html</marc:subfield>
					</xsl:when>


					<xsl:otherwise>
						<marc:subfield code="u">
							<xsl:value-of select="mods:location/mods:url"/>
						</marc:subfield>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:with-param>
		</xsl:call-template>


	</xsl:template>

	<xsl:template match="mods:relatedItem[@type='constituent']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">774</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- v3 changed this to not@type -->
	<!--<xsl:template match="mods:relatedItem[@type='related']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">787</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->
	<xsl:template name="relatedItem76X-78X">
		<xsl:for-each select="mods:titleInfo">
			<xsl:for-each select="mods:title">
				<xsl:choose>
					<xsl:when test="not(ancestor-or-self::mods:titleInfo/@type)">
						<marc:subfield code="t">
							<xsl:value-of
								select="replace(.,'Boston College Commencement photographs', 'Boston College Commencement materials')"/>
							<xsl:text>, </xsl:text>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="ancestor-or-self::mods:titleInfo/@type='uniform'">
						<marc:subfield code="s">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
					<xsl:when test="ancestor-or-self::mods:titleInfo/@type='abbreviated'">
						<marc:subfield code="p">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

					<xsl:for-each select="mods:partNumber">
						<marc:subfield code="g">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>
					<xsl:for-each select="mods:partName">
						<marc:subfield code="g">
							<xsl:value-of select="."/>
						</marc:subfield>
					</xsl:for-each>


		</xsl:for-each>

		<!--BC Custom, add dates subfield-->
		<xsl:if test="mods:originInfo">
			<xsl:choose>
				<!-- Handle bad relatedItem dates in athletics-->
				<xsl:when test="mods:identifier[@type='accession number']='BC.1986.019'">
					<marc:subfield code="d">
						<xsl:text>1889-2013, </xsl:text>
					</marc:subfield>
				</xsl:when>
				<xsl:otherwise>
					<marc:subfield code="d">
						<xsl:value-of select="mods:originInfo/mods:dateCreated[not(@*)]"/>
						<xsl:text>, </xsl:text>
					</marc:subfield>
				</xsl:otherwise>
			</xsl:choose>


		</xsl:if>

		<!--BC Custom, subseries-->
		<xsl:for-each select="mods:part/mods:detail">
			<xsl:choose>
				<xsl:when test="ancestor::mods:mods/mods:extension/mods:localCollectionName='MS1986043' or 'MS1986041'"/>
				<xsl:when test="mods:caption and mods:number and mods:title">
					<marc:subfield code="g">
						<xsl:value-of select="mods:caption"/>
						<xsl:text>: </xsl:text>
						<xsl:value-of select="mods:number"/>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="mods:title"/>
						<xsl:text>, </xsl:text>


					</marc:subfield>
				</xsl:when>
				<xsl:when test="mods:caption and mods:title">
					<marc:subfield code="g">
						<xsl:value-of select="mods:caption"/>
						<xsl:text>: </xsl:text>
						<xsl:value-of select="mods:title"/>
						<xsl:text>, </xsl:text>
					</marc:subfield>

				</xsl:when>

				<xsl:when test="mods:caption and mods:number">
					<marc:subfield code="g">
						<xsl:value-of select="mods:caption"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="mods:number"/>
						<xsl:text>, </xsl:text>
					</marc:subfield>
					<marc:subfield code="o">
						<xsl:if test="$isHanvey='true'">
							<xsl:text>MS.2001.039.</xsl:text>
						</xsl:if>
					</marc:subfield>
				</xsl:when>
			</xsl:choose>


		</xsl:for-each>
		<!-- 1/04 fix -->
		<xsl:call-template name="relatedItemNames"/>
		<!-- 1/04 fix -->
		<xsl:choose>
			<xsl:when test="@type='original'">
				<!-- 534 -->
				<xsl:for-each select="mods:physicalDescription/mods:extent">
					<marc:subfield code="e">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@type!='original'">
				<xsl:for-each select="mods:physicalDescription/mods:extent">
					<marc:subfield code="h">
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		<!-- v3 displaylabel -->
		<xsl:for-each select="@displayLabel">
			<marc:subfield code="i">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:note">
			<marc:subfield code="n">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:identifier[not(@type)]">
			<marc:subfield code="o">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:identifier[(@type='accession number')]">
			<marc:subfield code="o">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>


		<xsl:for-each select="mods:identifier[@type='issn']">
			<marc:subfield code="x">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:identifier[@type='isbn']">
			<marc:subfield code="z">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:identifier[@type='local']">
			<marc:subfield code="w">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>
		<xsl:for-each select="mods:note">
			<marc:subfield code="n">
				<xsl:value-of select="."/>
			</marc:subfield>
		</xsl:for-each>

	</xsl:template>

	<xsl:template name="relatedItemNames">
		<xsl:if test="mods:name">
			<marc:subfield code="a">
				<xsl:variable name="nameString">
					<xsl:for-each select="mods:name">
						<xsl:value-of select="mods:namePart[1][not(@type='date')]"/>
						<xsl:if test="mods:namePart[position()&gt;1][@type='date']">
							<xsl:value-of
								select="concat(' ',mods:namePart[position()&gt;1][@type='date'])"/>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="mods:role/mods:roleTerm[@type='text']">
								<xsl:value-of select="concat(', ',mods:role/mods:roleTerm)"/>
							</xsl:when>
							<xsl:when test="mods:role/mods:roleTerm[@type='code']">
								<xsl:value-of select="concat(', ',mods:role/mods:roleTerm)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
					<xsl:text>, </xsl:text>
				</xsl:variable>
				<xsl:value-of select="substring($nameString, 1,string-length($nameString)-2)"/>
			</marc:subfield>
		</xsl:if>
	</xsl:template>


	<!-- v3 not used?
		<xsl:variable name="leader06">
			<xsl:choose>
				<xsl:when test="mods:typeOfResource='text'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">t</xsl:when>
						<xsl:otherwise>a</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="mods:typeOfResource='cartographic'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">f</xsl:when>
						<xsl:otherwise>e</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="mods:typeOfResource='notated music'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">d</xsl:when>
						<xsl:otherwise>c</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="mods:typeOfResource='sound recording'">j</xsl:when>
				<xsl:when test="mods:typeOfResource='still image'">k</xsl:when>
				<xsl:when test="mods:typeOfResource='moving image'">g</xsl:when>
				<xsl:when test="mods:typeOfResource='three dimensional object'">r</xsl:when>
				<xsl:when test="mods:typeOfResource='software, multimedia'">m</xsl:when>
				<xsl:when test="mods:typeOfResource='mixed material'">p</xsl:when>
			</xsl:choose>
		</xsl:variable>
-->
</xsl:stylesheet>
