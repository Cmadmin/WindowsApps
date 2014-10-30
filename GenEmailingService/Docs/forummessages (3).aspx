<%@ Page Language="C#" CodeBehind="forummessages.aspx.cs" Inherits="MadeForMums.forum.forummessages" MaintainScrollPositionOnPostback="True" ValidateRequest="false" AutoEventWireup="false" 
    MasterPageFile="~/masterpages/maindotnet.master" Title="[ForumMessageList_ThreadView_ThreadTitleTopicTitleSiteName]"  PagePath="/Forum/Forum Messages" 
    Breadcrumb="<a href=&quot;/forum/&quot;>Forum</a> | <a href=&quot;[ForumMessageList_ThreadView_ForumUrl]&quot;>[ForumMessageList_ThreadView_ForumTitle]</a>" PageTitle="[ForumMessageList_ThreadView_ForumTitle]" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="MadeForMums.Models.Services" %>

<script runat="server" type="text/C#">
    
    public class PageDataProvider
    {
        public PageCollection GetByPageNumber(string currentPage, int threadId)
        {
            var data = new PageCollection
                {
                    {0, "/forum/thread.aspx?threadid=" + threadId + "?pageNum=33"},
                    {43, "/forum/thread.aspx?threadid=" + threadId + "?pageNum=34"},
                    {44, "/forum/thread.aspx?threadid=" + threadId + "?pageNum=35"},
                    {45, "/forum/thread.aspx?threadid=" + threadId + "?pageNum=36"},
                    {46, "/forum/thread.aspx?threadid=" + threadId + "?pageNum=47"}
                };

            //not strictly necessary
            data.CurrentPage = 45;
            data.TotalPages = 46;
            
            return data;
        }
    }
    
    public class PageCollection : Dictionary<int, string>
    {
        public int CurrentPage { get; set; }
        public int TotalPages { get; set; }
    }

    public PageCollection Pages { get; set; }

    protected override void OnInit(EventArgs e)
    {
        var service = new ForumRedirectService();
        service.CheckAndRedirect(Request);

        var pageDataProvider = new PageDataProvider();

        // what we're expecting back =  

        Pages = pageDataProvider.GetByPageNumber(Request.QueryString["PageNum"], thread.ThreadID);

    }
    
    
</script>

<asp:content ID="Content1" contentplaceholderid="main" runat="server">
    <script src="/resources/forum/ForumQuote.js" type="text/javascript"></script>
    
    <div class="forum-wrap ui-block forum-wrap--thread">
        <div class="im-responsive forum-thread-top">
            <div class="im-responsive im-tablet-wrap">
                <div class="im-column full-width forum-column-primary">
                     <ul class="no-list forum-sub-navigation hide-tablet hide-mobile">
                        <li class="va-m forum-sub-navigation__item"><a class="forum-sub-navigation__link" href="/forum/latest-posts/">Latest Posts</a></li>
                        <li class="va-m forum-sub-navigation__item"><a class="forum-sub-navigation__link" href="/forum/new-discussions/">New Discussions</a></li>
                         <% if (base.Member.IsLoggedIn) { %>
                        <li class="va-m forum-sub-navigation__item"><a class="forum-sub-navigation__link" href="/members/me/followed/">Followed Threads</a></li>
                        <li class="va-m forum-sub-navigation__item"><a href="#" class="start-thread js-start-thread">Start Thread</a></li>
                         <% } %>
                    </ul>
                </div>
                <div class="im-column forum-column-secondary">
                    <div class="forum-quick-links forum-quick-links">                    
                        <select title="" class="js-forum-quick-links forum-quick-links__select">
                            <option selected="selected">Quick links</option>
                            <option value="/forum/latest-posts/">Latest Posts</option>  
                            <option value="/forum/new-discussions/">New Discussions</option>
                            <option value="/members/me/followed/">Followed Threads</option>
                            <option value="js-start-thread">Start A New Thread</option>
                            <option value="/forum/">Chat</option>
                            <option value="/forum/area/getting-pregnant/1.html">Getting Pregnant</option>
                            <option value="/forum/area/pregnancy/2.html">Pregnancy</option>
                            <option value="/forum/area/birth-and-baby-clubs/3.html">Birth Clubs</option>
                            <option value="/forum/area/baby/4.html">Baby</option>
                            <option value="/forum/area/toddler-and-preschooler/8.html">Toddler</option>
                            <option value="/forum/area/school-and-family/5.html">School &amp; Family</option>
                            <option value="/forum/area/general-chat-products-and-comps/6.html">Chat, Product &amp Competitions</option>
                            <option value="/forum/area/talk-to-us/7.html">Talk To Us</option>
                        </select>                  
                    </div>
                </div>
            </div>

            <div class="f-left full-width">
                
                <%-- TODO: find out where this logo will be placed.  
                <div class="sponsor-container sponsor-forum-thread clearfix">
                    <mps:admanager ID="AdmanagerSponsor" format="180X80" position="SIDETOP" runat="server"></mps:admanager>
                </div>
               --%>

                <div class="thread-title <% if (thread.IsLockedThread) { %> thread-title--locked <% } %>">
                    <% if (base.Member.IsAdmin) { %>
                    <a class="forum-btn forum-btn--admin forum-btn--edit-thread js-edit-thread" data-threadId="<%= thread.ThreadID %>" href="#">Edit Thread</a>
                    <% } %>
                    <i class="forum-sprite thread-title__icon"></i>
                    <h1 class="thread-title__heading">
                        <%: thread.ThreadTitle %>
                    </h1>
                </div>
                
                <div class="forum-breadcrumbs">
                    <p class="forum-breadcrumbs__text"><a href="/forum/">Chat</a> < <a href="<%: thread.AreaUrl %>"><%: thread.AreaTitle %></a> < <a href="<%: thread.TopicUrl %>"><%: thread.TopicTitle %></a></p>
                </div>
             
			</div>
        </div>

        <div class="im-responsive im-tablet-wrap">         

            <div class="im-column full-width forum-column-primary">
                
                <div class="im-responsive">
                    <ul class="no-list im-column thread-activity-status">
                        <li class="thread-activity-status__item">
                            <i class="forum-sprite thread-activity-status__icon thread-activity-status__icon--view"></i>
                            <%: thread.NumberOfViews %><span class="hide-mobile"> views</span>
                        </li>
                        <li class="thread-activity-status__item">
                            <i class="forum-sprite thread-activity-status__icon thread-activity-status__icon--post"></i>
                            <%: thread.NumberOfPosts %><span class="hide-mobile"> posts</span>
                        </li>
                    </ul>
                    <div class="im-column see-last-post">
                        <a href="#post<%= LastPostid %>" class="js-see-last-post see-last-post__link">See last post</a>
                    </div>
                </div>
                
                <ul class="no-list forum__primary-action-buttons forum__primary-action-buttons--non-desktop hide-desktop">
                    <li class="no-list forum__primary-action-buttons__item forum__primary-action-buttons__item--space-right">
                        <a href="#" class="forum-btn forum-btn--has-icon forum-btn--add-post forum-btn--full-width js-add-post">
                            <span class="forum-btn__text">Add a Post</span>
                            <i class="forum-sprite forum-btn__icon forum-btn__icon--add-post"></i>
                        </a>
                    </li>
                    <li class="no-list forum__primary-action-buttons_item forum__primary-action-buttons__item--space-left">
                        <a href="#" class="forum-btn forum-btn--has-icon forum-btn--toggle forum-btn--follow forum-btn--full-width js-favourite-page <%= thread.IsFavouriteThread ? "forum-btn--is-followed" : null %>">
                            <span class="follow-btn__item follow-btn__item--follow">
                                <span class="forum-btn__text">Follow</span>
                                <i class="forum-sprite forum-btn__icon forum-btn__icon--follow"></i>
                            </span>
                            <span class="follow-btn__item follow-btn__item--unfollow"> 
                                <span class="forum-btn__text">Unfollow</span>
                                <i class="forum-sprite forum-btn__icon forum-btn__icon--unfollow"></i>
                            </span>
                        </a>
                    </li>   
                </ul>
                
                

                <div class="js-counter-container pagination-status">                    
                    <p>Displaying <span class="js-count-start"><%: Skip + 1 %></span> - <span class="count-current"><%: Math.Min(Skip + Take, thread.NumberOfPosts)  %></span> 
                    of <span class="count-total"><%: thread.NumberOfPosts %></span></p>
                </div>                

                <%-- START: NEW LAYOUT - FORUM THREAD --%>
                <ul class="js-forum-thread no-list forum-thread" data-threadid="<%: thread.ThreadID %>">
                    
                    <% foreach (var post in thread.Posts)
                       { %>
                    
                        <%--Note for BED's - Evaluate what the user type is so we can set the appropriate style--%> 
                        <%--Errr shouldn't user role be an Enum? We only need one for display purposes. --%> 
                        <% var postType = post.PostedByRoles.Contains("guest") ? "sponsor" : post.PostedByRoles.Contains("editor") 
                               ? "editor" : "user"; %>
                    
                        <li class="js-post-item post-item post-item--<%: postType %>" data-postid="<%: post.PostID %>">
                            <div class="row">
                                <div class="post-info">
                                    <a class="post-info__avatar-link" href="<%: post.PostedByUserUrl %>">
                                        <img class="post-info__avatar" src="<%: post.PostedByImageUrl%>" 
                                            alt="<%: post.PostedByName %>" />                                        
                                    </a>                                 
                                    <div class="post-info__details-wrap f-left">
                                        <a class="post-info__poster-name" href="<%: post.PostedByUserUrl %>"> 
                                            <%: post.PostedByName %>
                                        </a>
                                        <p class="post-info__post-time">Added <%= post.PostedByTime %></p>
                                    </div>
                                </div>
                                
                                <a data-membername="<%: post.PostedByName %>" title="click to message this user" href="#" 
                                    data-recipientid="<%: post.MemberId %>" class="message-poster js-send-msg">                                    
                                    <span class="va-m message-poster__item hide-mobile">Send a message</span>
                                    <span class="va-m message-poster__item hide-desktop hide-tablet">PM</span>
                                    <i class="forum-sprite message-poster__icon"></i>
                                </a>                             

                                <% if (Member.IsAdmin)
                                { %>
                                <a class="forum-btn forum-btn--admin forum-btn--edit-member admin-tool js-edit_member" href="#" 
                                    data-memberid="<%:post.MemberId %>">Edit Member</a>                             
                                <% } %>

                            </div>
                            <div class="row">
                                <div class="forum-thread__post-content">
                                    <%= post.PostHtml %>
                                </div>
                            </div>
                            <div class="row">
                                <div class="f-left">
                                   <%-- <% if (Member.MemberId != 0) { %>--%>
                                    <%--NB - REMOVE MEMBERID WHEN POSSIBLE -SECURITY HOLE--%>
                                    <% var isLiked = post.IsLikedByCurrentUser; %>
                                    <dl class="f-left like-post__list js-like-post__list">
                                        <dt class="va-m">
                                            <a class="va-m like-post__link js-like-post__link <% if (isLiked) { %>like-post__link--liked<% } %>" 
                                                data-memberid="<%= Member.MemberId %>" data-postid="<%: post.PostID %>" href="#">
                                                Helpful?<i class="forum-sprite post-action__icon like-post__icon--like <% if (isLiked) { %> like-post__icon--liked <% } %>"></i></a>                                            
                                        </dt>
                                        <dd class="js-like-post__count like-post__count"><%: post.NumberOfLikes %></dd>
                                    </dl>
                                   <%-- <% } %>--%>
                                    <div class="report-post f-left">
                                        <a data-memberid="<%= Member.MemberId %>" class="va-m report-post__link js-report-post__link" href="<%: post.ReportPostUrl %>">Report<i class="forum-sprite post-action__icon post-action__icon--report"></i></a>
                                    </div>                                    
                                </div>
                                                                                                  
                                <a href="#" class="forum-btn forum-btn--has-icon forum-btn--add-post forum-btn--add-post-mobile js-add-post hide-desktop">
                                    <span class="forum-btn__text forum-btn__text--has-icon">Add a Post</span>
                                    <i class="forum-sprite forum-btn__icon forum-btn__icon--add-post"></i>
                                </a>                                

                                <% if (Member.IsAdmin)
                                { %>
                                <div class="admin-tools admin-btns-wrap" data-postid="<%: post.PostID %>" data-memberid="<%: post.MemberId %>">
                                    <a href="#" class="forum-btn forum-btn--admin forum-btn--edit-message js-edit-message">Admin Edit</a>
                                    <a href="#" class="forum-btn forum-btn--admin forum-btn--delete-message js-delete-message">Delete post</a>                                    
                                </div>                             
                                <% } %>
                            </div>
                        </li>  

                    <% } %>
                    
                </ul>
                <%-- END: NEW LAYOUT - FORUM THREAD --%>

                <%--<div class="forum-advert" id="forum-advert-2">
				    <mps:container ID="Container3" shortname="forum-advert-bottom" name="Forum Advert Bottom" runat="server"></mps:container>
                </div>--%>
                
                <div class="js-counter-container pagination-status">
                    <p class="thread-display-count">Displaying <span class="js-count-start"><%: Skip + 1 %></span> - <span class="count-current"><%: Math.Min(Skip + Take, thread.NumberOfPosts)  %></span> 
                        of <span class="count-total"><%: thread.NumberOfPosts %></span></p>
                </div>
                
                
                <% if (Pages.TotalPages > 1)
                     { %>
                <ul class="no-list pagination-prev-next">                    
                    <li class="pagination-prev-next__item">
                        <% if (Pages.CurrentPage != 1) { %>
                        <a class="pagination-prev-next__link" href="/forum/thread.aspx?threadid=<%: thread.ThreadID %>?pageNum=<%: Pages.CurrentPage %>">< Previous</a>
                        <% } %>
                    </li>
                                      
                    <li class="pagination-prev-next__item">
                       <% if (Pages.TotalPages > 1 || Pages.CurrentPage != Pages.TotalPages)
                          { %>
                        <a class="pagination-prev-next__link" href="/forum/thread.aspx?threadid=<%: thread.ThreadID %>?pageNum=<%: Pages.CurrentPage + 2 %>">Next ></a>
                       <% } %>
                    </li>
                </ul>
                <% } %>
                
                

                <ul class="no-list pagination-page-controls">
                    <% foreach (var page in Pages)
                    { %>
                    
                        <% if (page.Key == Pages.CurrentPage)
                        { %> 
                            
                            <li class="forum-sprite pagination-page-controls__item pagination-page-controls__item--active">
                                <%= page.Key + 1 %>
                            </li>

                        <% } %>
                    
                        <% else {%>
                    
                            <% if (page.Key == Pages.TotalPages && Pages.TotalPages > 5 && Pages.TotalPages - Pages.CurrentPage > 4)
                            { %>
                                <li class="forum-sprite pagination-page-controls__item pagination-page-controls__item--has-elipsis">...</li>
                            <% } %>

                            <li class="forum-sprite pagination-page-controls__item">
                                <a class="pagination-page-controls__btn" href="<%= page.Value %>"><%= page.Key + 1 %></a>
                            </li>
                    
                            <% if ( page.Key == 0 && Pages.TotalPages > 5 && Pages.TotalPages - Pages.CurrentPage < 4 )
                            { %>
                                <li class="forum-sprite pagination-page-controls__item pagination-page-controls__item--has-elipsis">...</li>
                            <% } %>

                        <%}%>
                    <% } %>
                </ul>
                
                
                <div class="js-thread-link-container">
                    <a href="/forum/thread.aspx?threadid=<%= ThreadId %>Skip=<%: Skip + Take %>&Take=<%: Take %>&Order=<%: Order %>" class="load-more js-load-more <%:IsDisabled %>">Load 
                        Next <%: Take %></a>
                </div>
                            
                <div class="addPost mb20 js-post-form">
                    
                    <% if (thread.IsLockedThread)
                       { %>
                    
                            <div class="addPost__div--signin">
							    <span class="addPost__icon--locked">This thread is locked</span>
						    </div>
					<% }
                       else
                       { %>

	                <% if (Member.IsLoggedIn)
	                   { %>	<!-- Displays if the user IS logged in -->

						<div class="addPost__div--row addPost__div--header">
						    
                            <h2 class="addPost__header">Add a post</h2>
							<div class="avatar">
							    <div class="avatar_wrapper--img">
								    <img class="avatar__img f-left" src="<%= Member.Image == "" ? "/members/images/profilepicture.png" :
								                                                 Member.Image %>" alt="" />
								</div>
                                <a class="avatar__link--member" href="/members/me/">
                                    <span class="avatar__span--name f-left"><%= Member.Nickname %></span>
                                </a> says:                         
							</div> 

						</div>

						<div class="addPost__div--row addPost__div--content">
                            <textarea class="js-post-form-text"></textarea>
						</div>
							    
						<div class="addPost__div--row">
							<a href="http://www.immediatemedia.co.uk/terms-and-conditions/"><em>Terms and Conditions</em></a> | 
                            <a href="http://www.immediate.co.uk/website-code-of-conduct/"><em>Code of Conduct</em></a>
						</div>

						<div class="addPost__div--row custom-tickbox">
							<input type="checkbox" id="post-email" class="js-post-form-email addPost__radio--response" 
                                <%= thread.IsUserSubscribedToThread ? "checked" : "" %> />
									
                            <label class="addPost__label--response" for="post-email">Email me when a response is made</label>
						</div>

						<div class="addPost__div--row ">
							<a href="#" class="btn addPost__btn--post js-post-form-submit is-disabled">Add your post</a>
						</div>


					<% }
	                   else
	                   { %>	<!-- Displays if the user IS NOT logged in -->

                            <div class="addPost__div--signin">

							        <a href="/Members/register" class="js-login-prompt addPost__link">Sign In</a> or
							        <a href="/Members/join/" class="addPost__link">Register</a> to write a post.

						    </div>
                            <img src="/images/forum/addpost.png" class="addPost__img--signin f-left clearfix mb20" alt=""/>

					    <% } %>
					<% } %>


                    </div> <!-- end of add-post section -->     
                
                    <div class="forum-featured-discussion">   
                        <h2 class="line-break-bottom">Featured Discussions</h2>
                        <mps:container ID="Container1" shortname="forum_right_column" name="forum view - right column" runat="server"></mps:container>
                    </div>
                </div>
            
                <div class="im-column js-forum-column-secondary forum-column-secondary">
                    <div class="js-forum-fixed-wrapper forum-fixed-wrapper hide-mobile hide-tablet">
                        <%-- START: Primary forum buttons --%>
                        <ul class="no-list forum__primary-action-buttons">
                            <li class="no-list forum__primary-action-buttons__item forum__primary-action-buttons__item--space-right">
                                <a href="#" class="forum-btn forum-btn--has-icon forum-btn--add-post forum-btn--full-width js-add-post">
                                    <span class="forum-btn__text">Add a Post</span>
                                    <i class="forum-sprite forum-btn__icon forum-btn__icon--add-post"></i>
                                </a>
                            </li>
                            <li class="no-list forum__primary-action-buttons_item forum__primary-action-buttons__item--space-left">
                                <a href="#" class="forum-btn forum-btn--has-icon forum-btn--toggle forum-btn--follow forum-btn--full-width js-favourite-page <%= thread.IsFavouriteThread ? "forum-btn--is-followed" : null %>">
                                    <span class="follow-btn__item follow-btn__item--follow">
                                        <span class="forum-btn__text">Follow</span>
                                        <i class="forum-sprite forum-btn__icon forum-btn__icon--follow"></i>
                                    </span>
                                    <span class="follow-btn__item follow-btn__item--unfollow"> 
                                        <span class="forum-btn__text">Unfollow</span>
                                        <i class="forum-sprite forum-btn__icon forum-btn__icon--unfollow"></i>
                                    </span>
                                </a>
                            </li>   
                        </ul>                  
                        <%-- END: Primary forum buttons --%>

                        <div class="forum-advert" id="forum-advert-1">
				            <mps:container ID="Container2" shortname="forum-advert-top" name="Forum Advert Top" runat="server"></mps:container>
                        </div>
                        <div class="forum-threads forum-threads--busiest">
                            <h3 class="forum-threads__heading">Busiest Threads in Pregnancy</h3>
                            <div class="forum-threads__block">
                                <a class="forum-threads__title">Baby dust to all...Fingers crossed for BFP</a>
                                <span><i class="forum-sprite forum-threads__num-posts"></i>57 posts</span>
                            </div>
                            <div class="forum-threads__block">
                                <a class="forum-threads__title">Baby dust to all...Fingers crossed for BFP</a>
                                <span><i class="forum-sprite forum-threads__num-posts"></i>57 posts</span>
                            </div>
                            <div class="forum-threads__block">
                                <a class="forum-threads__title">Baby dust to all...Fingers crossed for BFP</a>
                                <span><i class="forum-sprite forum-threads__num-posts"></i>57 posts</span>
                            </div>
                        </div>
                        <div class="cta">
                        <% if (!Member.IsLoggedIn)
                           { %>
                            <div class="cta__block--signin">
                                <div class="cta__block--content">
                                    <img class="cta__image" src="/images/forum/heynewbie.png" alt="Hey Newbie" />
                                    <p class="cta__para">Please nose around, check out the chat, <a href="/members/join/" class="js-login-prompt cta_block--link">sign in</a> and get stuck in.</p>
                                </div>
                            </div>
                        <% } %>
                        </div>
                    </div>
                    <div class="hide-desktop">
                        <div class="forum-advert" id="forum-advert-2">
				            <%--<mps:container ID="Container4" shortname="forum-advert-bottom" name="Forum Advert Bottom" runat="server"></mps:container>--%>
                        </div>
                        <ul class="forum-sub-navigation hide-desktop">
                            <li class="va-m forum-sub-navigation__item">
                                <a class="forum-sub-navigation__link" href="/forum/latest-posts/"><span>Latest Posts</span><i class="forum-sprite forum-sub-navigation__icon"></i></a>
                            </li>
                            <li class="va-m forum-sub-navigation__item">
                                <a class="forum-sub-navigation__link" href="/forum/new-discussions/"><span>New Discussions</span><i class="forum-sprite forum-sub-navigation__icon"></i></a>
                            </li>
                            <li class="va-m forum-sub-navigation__item">
                                <a class="forum-sub-navigation__link" href="/members/me/followed/"><span>Followed Threads</span><i class="forum-sprite forum-sub-navigation__icon"></i></a>
                            </li>
                            <li class="va-m forum-sub-navigation__item">
                                <a href="#" class="start-thread js-start-thread"><span>Start Thread</span><i class="forum-sprite forum-sub-navigation__icon"></i></a>
                            </li>
                        </ul>
                        <div class="forum-threads forum-threads--busiest">
                            <h3 class="forum-threads__heading">Busiest Threads in Pregnancy</h3>
                            <div class="forum-threads__block">
                                <a class="forum-threads__title">Baby dust to all...Fingers crossed for BFP</a>
                                <span><i class="forum-sprite forum-threads__num-posts"></i>57 posts</span>
                            </div>
                            <div class="forum-threads__block">
                                <a class="forum-threads__title">Baby dust to all...Fingers crossed for BFP</a>
                                <span><i class="forum-sprite forum-threads__num-posts"></i>57 posts</span>
                            </div>
                            <div class="forum-threads__block">
                                <a class="forum-threads__title">Baby dust to all...Fingers crossed for BFP</a>
                                <span><i class="forum-sprite forum-threads__num-posts"></i>57 posts</span>
                            </div>
                        </div>
                        <a href="#" class="forum-btn forum-btn--has-icon forum-btn--new-thread forum-btn--full-width js-start-thread"><span class="forum-btn__text">Start A Thread</span><i class="forum-sprite forum-btn__icon forum-btn__icon--new-thread"></i></a>
                        <div class="forum-quick-links forum-quick-links">                    
                            <select title="" class="js-forum-quick-links forum-quick-links__select">
                                <option selected="selected">Quick links</option>
                                <option value="/forum/latest-posts/">Latest Posts</option>  
                                <option value="/forum/new-discussions/">New Discussions</option>
                                <option value="/members/me/followed/">Followed Threads</option>
                                <option value="js-start-thread">Start A New Thread</option>
                                <option value="/forum/">Chat</option>
                                <option value="/forum/area/getting-pregnant/1.html">Getting Pregnant</option>
                                <option value="/forum/area/pregnancy/2.html">Pregnancy</option>
                                <option value="/forum/area/birth-and-baby-clubs/3.html">Birth Clubs</option>
                                <option value="/forum/area/baby/4.html">Baby</option>
                                <option value="/forum/area/toddler-and-preschooler/8.html">Toddler</option>
                                <option value="/forum/area/school-and-family/5.html">School &amp; Family</option>
                                <option value="/forum/area/general-chat-products-and-comps/6.html">Chat, Product &amp Competitions</option>
                                <option value="/forum/area/talk-to-us/7.html">Talk To Us</option>
                            </select>                  
                        </div>
                        <div class="ui-anchor">
                            <a href="#containerbody" class="ui-anchor__btn js-ui-anchor__button">Back to top<i class="forum-sprite ui-anchor__icon"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</asp:content>

<asp:content ID="Content5" contentplaceholderid="script" runat="server">
    <%: Scripts.Render("~/Bundles/FileAPIScripts") %>
    <%: Scripts.Render("~/Scripts/jquery/jquery.tiny_mce") %>
    <%: Scripts.Render("~/Scripts/Modules/forums/thread") %>
        
    <script type="text/javascript">var switchTo5x = true;</script>
    <script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>
    <script type="text/javascript">stLight.options(
        {
            publisher: "4cbe3169-73f1-4d6e-9d75-6fdab97c4d08",
            doNotHash: false, doNotCopy: false, hashAddressBar: false
        });

    </script>

</asp:content>