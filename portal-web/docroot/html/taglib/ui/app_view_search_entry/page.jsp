<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/taglib/ui/app_view_search_entry/init.jsp" %>

<%
String actionJsp = (String)request.getAttribute("liferay-ui:app-view-search-entry:actionJsp");
String containerIcon = GetterUtil.getString(request.getAttribute("liferay-ui:app-view-search-entry:containerIcon"), "folder");
String containerName = (String)request.getAttribute("liferay-ui:app-view-search-entry:containerName");
String containerType = GetterUtil.getString(request.getAttribute("liferay-ui:app-view-search-entry:containerType"), LanguageUtil.get(locale, "folder"));
String cssClass = (String)request.getAttribute("liferay-ui:app-view-search-entry:cssClass");
String description = (String)request.getAttribute("liferay-ui:app-view-search-entry:description");
List<FileEntry> fileEntries = (List<FileEntry>)request.getAttribute("liferay-ui:app-view-search-entry:fileEntries");
boolean locked = GetterUtil.getBoolean(request.getAttribute("liferay-ui:app-view-search-entry:locked"));
List<MBMessage> mbMessages = (List<MBMessage>)request.getAttribute("liferay-ui:app-view-search-entry:mbMessages");
String[] queryTerms = (String[])request.getAttribute("liferay-ui:app-view-search-entry:queryTerms");
String rowCheckerId = (String)request.getAttribute("liferay-ui:app-view-search-entry:rowCheckerId");
String rowCheckerName = (String)request.getAttribute("liferay-ui:app-view-search-entry:rowCheckerName");
boolean showCheckbox = GetterUtil.getBoolean(request.getAttribute("liferay-ui:app-view-search-entry:showCheckbox"));
int status = GetterUtil.getInteger(request.getAttribute("liferay-ui:app-view-search-entry:status"));
String thumbnailSrc = (String)request.getAttribute("liferay-ui:app-view-search-entry:thumbnailSrc");
String title = (String)request.getAttribute("liferay-ui:app-view-search-entry:title");
String url = (String)request.getAttribute("liferay-ui:app-view-search-entry:url");
%>

<div class="app-view-entry app-view-search-entry-taglib entry-display-style <%= showCheckbox ? "selectable" : StringPool.BLANK %> <%= cssClass %>" data-title="<%= HtmlUtil.escapeAttribute(StringUtil.shorten(title, 60)) %>">
	<a class="entry-link" href="<%= url %>" title="<%= HtmlUtil.escapeAttribute(title + " - " + description) %>">
		<c:if test="<%= Validator.isNotNull(thumbnailSrc) %>">
			<div class="entry-thumbnail">
				<img alt="" class="entry-thumbnail-image" src="<%= thumbnailSrc %>" />

				<c:if test="<%= locked %>">
					<img alt="<liferay-ui:message key="locked" />" class="locked-icon" src="<%= themeDisplay.getPathThemeImages() %>/file_system/large/overlay_lock.png" />
				</c:if>
			</div>
		</c:if>

		<span class="entry-title">
			<%= StringUtil.highlight(HtmlUtil.escape(title), queryTerms) %>

			<c:if test="<%= ((status == WorkflowConstants.STATUS_DRAFT) || (status == WorkflowConstants.STATUS_PENDING)) %>">

				<%
				String statusLabel = WorkflowConstants.toLabel(status);
				%>

				<span class="workflow-status-<%= statusLabel %>">
					(<liferay-ui:message key="<%= statusLabel %>" />)
				</span>
			</c:if>
		</span>

		<c:if test="<%= Validator.isNotNull(containerName) %>">
			<span class="entry-folder">
				<liferay-ui:icon
					image='<%= (Validator.isNotNull(containerIcon)) ? containerIcon : "folder" %>'
					label="<%= true %>"
					message='<%= LanguageUtil.format(locale, "found-in-x-x", new String[]{containerType, containerName}) %>'
				/>
			</span>
		</c:if>

		<span class="entry-description">
			<%= StringUtil.highlight(HtmlUtil.escape(description), queryTerms) %>
		</span>
	</a>

	<c:if test="<%= fileEntries != null %>">


		<%
		for (FileEntry fileEntry : fileEntries) {
		%>

			<div class="entry-attachment">
				<aui:a class="lfr-discussion-details" href="<%= url %>">
					<div class="image">
						<img alt="<%= fileEntry.getTitle() %>" class="attachment" src="<%= DLUtil.getThumbnailSrc(fileEntry, null, themeDisplay) %>" />
					</div>

						<span class="title">
							<liferay-ui:icon
								image='<%= "../file_system/small/" + DLUtil.getFileIcon(fileEntry.getExtension()) %>'
								label="<%= true %>"
								message='<%= LanguageUtil.format(locale, "attachment-added-by-x", HtmlUtil.escape(fileEntry.getUserName())) %>'
							/>
						</span>

						<span cssClass="body">
							<%= StringUtil.highlight(fileEntry.getTitle(), queryTerms) %>
						</span>
				</aui:a>
			</div>

		<%
		}
		%>

	</c:if>

	<c:if test="<%= mbMessages != null %>">

		<%
		for (MBMessage mbMessage : mbMessages) {
			User userDisplay = UserLocalServiceUtil.getUser(mbMessage.getUserId());
		%>

			<div class="entry-discussion">
				<aui:a class="lfr-discussion-details" href="<%= url %>">
					<div class="image">
						<img alt="<%= HtmlUtil.escapeAttribute(userDisplay.getFullName()) %>" class="avatar" src="<%= HtmlUtil.escape(userDisplay.getPortraitURL(themeDisplay)) %>" />
					</div>

					<span class="title">
						<liferay-ui:icon
							image="message"
							label="<%= true %>"
							message='<%= LanguageUtil.format(locale, "comment-by-x", HtmlUtil.escape(userDisplay.getFullName())) %>'
						/>
					</span>

					<span cssClass="body">
						<%= StringUtil.highlight(mbMessage.getSubject(), queryTerms) %>
					</span>
				</aui:a>
			</div>

		<%
		}
		%>

	</c:if>

	<c:if test="<%= showCheckbox %>">
		<aui:input cssClass="overlay entry-selector" label="" name="<%= RowChecker.ROW_IDS + rowCheckerName %>" type="checkbox" value="<%= rowCheckerId %>" />
	</c:if>

	<c:if test="<%= Validator.isNotNull(actionJsp) %>">
		<liferay-util:include page="<%= actionJsp %>">
			<liferay-util:param name="showMinimalActionButtons" value="<%= String.valueOf(Boolean.TRUE) %>" />
		</liferay-util:include>
	</c:if>
</div>