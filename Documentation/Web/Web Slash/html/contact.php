<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<?php
//==============
//CONFIGURATION
//==============

//IMPORTANT!!
//Put in your email address below:
$to = 'dlm87@mail.ru';


//User info (DO NOT EDIT!)
$name = stripslashes($_POST['name']); //sender's name
$email = stripslashes($_POST['email']); //sender's email
$website = stripslashes($_POST['website']); //sender's website

//The subject
$subject  = "[LightFormX Contact Form] "; //The default subject. Will appear by default in all messages. Change this if you want.
$subject .= stripslashes($_POST['subject']); // the subject


//The message you will receive in your mailbox
//Each parts are commented to help you understand what it does exaclty.
//YOU DON'T NEED TO EDIT IT BELOW BUT IF YOU DO, DO IT WITH CAUTION!
$msg  = "From : $name \r\n";  //add sender's name to the message
$msg .= "e-Mail : $email \r\n";  //add sender's email to the message
$msg .= "Website : $website \r\n"; //add sender's website to the message
$msg .= "Subject : $subject \r\n\n"; //add subject to the message (optional! It will be displayed in the header anyway)
$msg .= "---Message--- \r\n".stripslashes($_POST['message'])."\r\n\n";  //the message itself

//Extras: User info (Optional!)
//Delete this part if you don't need it
//Display user information such as Ip address and browsers information...
$msg .= "---User information--- \r\n"; //Title
$msg .= "User IP : ".$_SERVER["REMOTE_ADDR"]."\r\n"; //Sender's IP
$msg .= "Browser info : ".$_SERVER["HTTP_USER_AGENT"]."\r\n"; //User agent
$msg .= "User come from : ".$_SERVER["HTTP_REFERER"]; //Referrer
// END Extras

?>
<head>
<link rel="icon" type="image/x-icon" href="favicon.ico" />
<link rel="shortcut icon"  href="favicon.ico" type="image/x-icon"  />
<title>WebSplash - Contact Us</title>

<meta name="keywords" content=""/>
<meta name="description" content="" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<link href='http://fonts.googleapis.com/css?family=Droid+Serif:400italic|Oswald' rel='stylesheet' type='text/css' />
<link rel="stylesheet" href="layout/style.css" type="text/css"/>
<link rel="stylesheet" href="layout/themes/theme_style.css" type="text/css"/>
<link rel="stylesheet" href="layout/plugins_styles/nivo-slider.css" type="text/css"/><!-- Necessary for Nivo slider -->
<link rel="stylesheet" href="layout/plugins_styles/prettyPhoto.css" type="text/css"/><!-- Necessary for Popups -->
<link rel="stylesheet" href="layout/plugins_styles/form.css" type="text/css" media="screen" />


<script src="layout/js/jquery-1.6.min.js" type="text/javascript"></script>
<script type="text/javascript" src="layout/js/main.js"></script>

<script type="text/javascript" src="layout/js/jquery.prettyPhoto.js"></script><!-- Necessary for Popups -->
<script type="text/javascript" src="layout/js/popups.js"></script>

<script type="text/javascript" src="layout/js/jquery.cookie.js"></script>
<script type="text/javascript" src="layout/js/theme_settings.js"></script>



<!-- contact form -->

<script src="layout/js/languages/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
<script src="layout/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8">
	jQuery(document).ready(function(){
		// binds form submission and fields to the validation engine
		jQuery("#cont_form").validationEngine();
	});

</script>
</head>

<body>
<div class="pattern"></div>
<div class="main_bg"></div>
<div class="wrapper">
    	<!-- HEADER BEGIN -->
        <div id="header">
        	<div class="inner">
            	<div class="section_top">
                	<div class="block_top_text"><p>WebSplash - number one in business</p></div>
                    
                    <div class="block_search">
                    	<div id="search_show" class="button">Search</div>
                        
                        <div id="search_form_block" class="form_wrapper">
                            <div class="form">
                                <form action="#">
                                    <div class="field"><input type="text" class="w_def_text" title="Site search" /></div>
                                    <input type="submit" class="button" value="Search" />
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <div class="block_top_lnks">
                    	<ul>
                        	<li><a href="#sign_popup" name="sign_pop" rel="prettyPhoto[gallery0]">Sign in</a></li>
						<li><a href="#reg_popup" name="reg_pop" rel="prettyPhoto[gallery00]">Registration</a></li>
                        </ul>
                    </div>
                </div>
                
                <div class="section_bottom">
                	<div id="title_top"><p><a href="home.html"><img src="layout/images/spacer.gif" alt="WebSplash" title="WebSplash" /></a></p></div>
                    
                    <div id="main_menu">
					<ul>
						<li><a href="home.html">Home</a>
							<ul>
								<li><a href="home.html">Home page</a></li>
								<li><a href="alternative_home_page.html">Alternative Layout</a></li>
							</ul>
						</li>
						<li><a href="slider_accordion.html">Sliders</a>
							<ul>
								<li><a href="home.html">Basic slider</a></li>
								<li><a href="slider_nivo.html">Nivo slider</a></li>
								<li><a href="slider_thumbnail.html">Thumbnail slider</a></li>
								<li><a href="slider_accordion.html">Accordion slider</a></li>
								<li><a href="slider_left.html">Left Slider</a></li>
								<li><a href="slider_right.html">Right Slider</a></li>
								<li><a href="slider_3d.html">3D slider</a></li>
							</ul>
						</li>
						<li><a href="additional_elements.html">Features</a>
							<ul>
								<li><a href="pricing_table.html">Pricing table</a></li>
								<li><a href="additional_elements.html">Additional elements</a></li>
								<li><a href="columns.html">Columns</a></li>
								<li><a href="services.html">Services</a></li>
								<li><a href="archives.html">Archives</a></li>
								<li><a href="404.html">Page 404</a></li>
							</ul>
						</li>
						<li><a href="portfolio_2c.html">Portfolio</a>
							<ul>
								<li><a href="portfolio_2c.html">Portfolio 2 columns</a></li>
								<li><a href="portfolio_3c.html">Portfolio 3 columns</a></li>
								<li><a href="portfolio_4c.html">Portfolio 4 columns</a></li>
								<li><a href="portfolio_with_sidebar_2c.html">Portfolio With Right Sidebar</a>
									<ul>
										<li><a href="portfolio_with_sidebar_2c.html">2 Columns Right Sidebar</a></li>
										<li><a href="portfolio_with_sidebar_3c.html">3 Columns Right Sidebar</a></li>
									</ul>							
								</li>
								<li><a href="portfolio_with_link_2c.html">Portfolio With Link Button</a>
									<ul>
										<li><a href="portfolio_with_link_2c.html">2 Columns With Link Button</a></li>
										<li><a href="portfolio_with_link_3c.html">3 Columns With Link Button</a></li>
										<li><a href="portfolio_with_link_4c.html">4 Columns With Link Button</a></li>
									</ul>							
								</li>
								<li><a href="portfolio_gallery.html">Portfolio Gallery Style </a>
									<ul>
										<li><a href="portfolio_gallery.html">Gallery With Right Sidebar</a></li>
										<li><a href="portfolio_gallery_full.html">Galley Full Width</a></li>
									</ul>							
								</li>
								<li><a href="portfolio_item.html">Portfolio Item Page</a></li>
							</ul>
						</li>
						<li><a href="blog_1.html">Blog</a>
							<ul>
								<li><a href="blog_1.html">Blog Style 1</a></li>
								<li><a href="blog_2.html">Blog Style 2</a></li>
								<li><a href="blog_right_1.html">Blog Style 3</a></li>
								<li><a href="blog_right_2.html">Blog Style 4</a></li>
								<li><a href="blog_right_3.html">Blog Style 5</a></li>
								<li><a href="blog_full_width.html">Blog full width</a></li>
								<li><a href="blog_post.html">Blog post page</a></li>
							</ul>
						</li>
						<li><a href="about.html">About</a></li>
						<li class="active"><a href="contact.php">Contact</a></li>
					</ul>
				</div>
                </div>
            </div>
        </div>
        <!-- HEADER END -->
        
        <!-- CONTENT BEGIN -->
        <div id="content" class="block_typography">
        	<div class="inner">
            	<div class="block_content_top">
                	<div class="block_page_title">
                    	<p class="title">Contact</p>
                        <p class="subtitle">This is a custom subpage description.</p>
                    </div>
                    
                    <div class="block_back"><p><a href="home.html">Back to Home Page »</a></p></div>
                </div>
                
                <div class="separator_1"></div>
                
                <div class="block_two_columns">
					<div class="column_12 fl">
						<h1 class="mb_9">Contact Form</h1>
						<p>Established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that. Has a more-or-less normal. Of letters, as opposed to using content here, content here, making it look like readable English.</p>
						<div class="separator_1"></div>
						<div class="block_contact_form">
						<?php
						   if ($_SERVER['REQUEST_METHOD'] != 'POST'){
							  $self = $_SERVER['PHP_SELF'];
						?>
							<form method="post" id="cont_form" action="">
								<p>Name<span>*</span></p>
								<div class="field ">
									<input type="text" class="w_focus validate[required] text-input" size="33" name="name" id="name" />
								</div>
								<p>Subject</p>
								<div class="field">
									<input type="text" class="w_focus text-input" size="33" name="subject" id="subject"  />
								</div>
								<p>E-mail<span>*</span></p>
								<div class="field">
									<input type="text" class="w_focus validate[required,custom[email]] text-input" size="33" name="email" id="email"  />
								</div>
								<p>Message<span>*</span></p>
								<div class="textarea">
									<textarea cols="52" rows="12" name="message" id="message" class="w_focus validate[required]"></textarea>
								</div>
								<div class="send"><span class="button_lnk blue def_link">
									<input type="submit" value="Send Message" class="submit" />
									</span></div>
							</form>
							<?php
								} else {
									error_reporting(0);
							
									if  (mail($to, $subject, $msg, "From: $email\r\nReply-To: $email\r\nReturn-Path: $email\r\n"))
							
									//Message sent!
									//It the message that will be displayed when the user click the sumbit button
									//You can modify the text if you want
									echo nl2br("
									<span class='MsgSent'>
										<h1>Congratulations!!</h1>
										Thank you <?=$name;?>, your message is sent!<br /> I will get back to you as soon as possible.
									</span>
								   ");
							
									else
							
									// Display error message if the message failed to send
									echo "
									<span class='MsgError'>
										<h1>Error!!</h1>
										Sorry <?=$name;?>, your message failed to send. Try later!
									</span>";
								}
							?>
						</div>
					</div>
					<div class="column_13 fr">
						<div class="block_map">
							<h1>Google Map</h1>
							<div class="block_general_pic">
								<iframe width="320" height="196" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="http://maps.google.com.ua/maps?f=q&amp;source=s_q&amp;hl=ru&amp;q=200+E+Chase+St,+Baltimore,+Maryland+21202,+%D0%A1%D0%BE%D0%B5%D0%B4%D0%B8%D0%BD%D1%91%D0%BD%D0%BD%D1%8B%D0%B5+%D0%A8%D1%82%D0%B0%D1%82%D1%8B+%D0%90%D0%BC%D0%B5%D1%80%D0%B8%D0%BA%D0%B8&amp;aq=&amp;sll=39.301906,-76.611271&amp;sspn=0.003304,0.006968&amp;vpsrc=6&amp;ie=UTF8&amp;geocode=FUi2VwIdf_xu-w&amp;split=0&amp;hq=&amp;hnear=200+E+Chase+St,+Baltimore,+Maryland+21202,+%D0%A1%D0%BE%D0%B5%D0%B4%D0%B8%D0%BD%D1%91%D0%BD%D0%BD%D1%8B%D0%B5+%D0%A8%D1%82%D0%B0%D1%82%D1%8B+%D0%90%D0%BC%D0%B5%D1%80%D0%B8%D0%BA%D0%B8&amp;ll=39.302728,-76.612481&amp;spn=0.026434,0.055747&amp;t=m&amp;z=14&amp;output=embed"></iframe>
							</div>
						</div>
						<div class="separator_11"></div>
						<div class="block_contact_info">
							<h1>Our Contact Detail</h1>
							<p>When looking at its layout. The point of using Lorem Ipsum is that. Has a more-or-less normal.</p>
							<div class="separator_13"></div>
							<p><b>Corporate info:</b> Maryland, USA, 25689</p>
							<p class="text_w_space"><b>Phone:</b> +1 258 598 25 66</p>
							<p class="text_w_space"><b>Fax:</b> +1 514 457 55 63</p>
							<p class="text_w_space"><b>Email:</b> <a href="mailto:#" target="_blank">info@websplash.com</a></p>
						</div>
					</div>
					<div class="separator_0"></div>
				</div>
                
        	</div>
        </div>
        <!-- CONTENT END -->
          
        <!-- FOOTER BEGIN -->
        <div id="footer">
            <div class="section_top">
            	<div class="inner">
                	<div class="col_1">
                        <div id="title_bottom"><p><a href="home.html"><img src="layout/images/spacer.gif" alt="WebSplash" title="WebSplash" /></a></p></div>
                        
                        <p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration some form, by injected  randomised words which don't look even slightly If you are going to use... <a href="#"><img src="layout/images/arrow_6.gif" alt="" /></a></p>
                    </div>
                    
                    <div class="col_2">
                    	<h3>Latest Tweets</h3>
                        
                        <div class="block_footer_latest_tweets">
                        	<p>8 Web Marketing &amp; Joomla Development Services For Online</p>
                            <p><a href="#">http://bit.ly/rlsT7h</a></p>
                            <p class="date">15 minutes ago</p>
                        </div>
                        
                        <div class="line_2"></div>
                        
                        <div class="block_footer_latest_tweets">
                        	<p>Tumblr Importer plugin lets you move blog from Tumblr to WordPress</p>
                            <p><a href="#">http://thenextweb.com/apps/2011</a></p>
                            <p class="date">26 minutes ago</p>
                        </div>
                    </div>
                    
                    <div class="col_3">
                    	<h3>Recent Posts</h3>
                        
                        <div class="block_footer_recent_posts">
                            <p><a href="#">There are many variations of passages of Lorem Ipsum available...</a></p>
                            <p class="date">September 15, 2011 - 10 Comments</p>
                        </div>
                        
                        <div class="line_2"></div>
                        
                        <div class="block_footer_recent_posts">
                        	<p><a href="#">Available, but the majority have suffered alteration in some form, by injected humour...</a></p>
                            <p class="date">May 18, 2011 - 10 Comments</p>
                        </div>
                    </div>
                    
                    <div class="col_4">
                    	<h3>Flickr</h3>
                        
                        <div class="block_flickr">
                        	<a href="http://www.flickr.com/" target="_blank"><img src="images/45x45/pic_flickr_1.jpg" alt="" /><span>&nbsp;</span></a>
                            <a href="http://www.flickr.com/" target="_blank"><img src="images/45x45/pic_flickr_2.jpg" alt="" /><span>&nbsp;</span></a>
                            <a href="http://www.flickr.com/" target="_blank"><img src="images/45x45/pic_flickr_3.jpg" alt="" /><span>&nbsp;</span></a>
                            <a href="http://www.flickr.com/" target="_blank"><img src="images/45x45/pic_flickr_4.jpg" alt="" /><span>&nbsp;</span></a>
                            <a href="http://www.flickr.com/" target="_blank"><img src="images/45x45/pic_flickr_5.jpg" alt="" /><span>&nbsp;</span></a>
                            <a href="http://www.flickr.com/" target="_blank"><img src="images/45x45/pic_flickr_6.jpg" alt="" /><span>&nbsp;</span></a>
                            <a href="http://www.flickr.com/" target="_blank"><img src="images/45x45/pic_flickr_7.jpg" alt="" /><span>&nbsp;</span></a>
                            <a href="http://www.flickr.com/" target="_blank"><img src="images/45x45/pic_flickr_8.jpg" alt="" /><span>&nbsp;</span></a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="section_bottom">
            	<div class="inner">
                	<div class="block_copyrights"><p>Copyright &copy; 2010 Web Splash. Theme by Web Vision</p></div>
                    
                    <div class="block_follow_us">
                    	<div class="text"><p>Follow us:</p></div>
                        
                        <div class="block_social_1 fl">
                        	<a href="#" class="twitter">Twitter</a>
                            <a href="#" class="facebook">Facebook</a>
                            <a href="#" class="rss">RSS</a>
                            <a href="#" class="linked_in">Linked In</a>
                            <a href="#" class="deviart">Deviart</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
       <!-- FOOTER END --> 
</div>
<!-- sign form -->
<div class="disp_none">
	<div id="reg_popup">
		<div class="sign_popup">
			<h2>Registration</h2>
			<h3>Register in to your account</h3>
			<form action="" method="post" id="f_sign">
				<div class="inp_line">
					<label>Login:</label>
					<div class="field"><input type="text" class="w_focus" name="name" /></div>
				</div>
				<div class="inp_line">
					<label>E-mail:</label>
					<div class="field"><input type="text" class="w_focus" name="email" /></div>
				</div>
				<div class="inp_line">
					<label>Password:</label>
					<div class="field"><input type="text" class="w_focus" name="passw" /></div>
				</div>
				<div class="inp_checkbox">
					<div class="inp_checkbox_in"><label><input type="checkbox" checked="checked" value="" class="styled" name="ch1" id="ch1" />
						<span>Remember me?</span> </label></div>
					<a href="javascript:;" onclick="document.forms['f_sign'].submit();" class="button_lnk blue fl def_link"><span>Register</span></a> </div>
			</form>
		</div>
	</div>
	
	<div id="sign_popup">
		<div class="sign_popup">
			<h2>Authorization on the site</h2>
			<h3>Sign in to your account</h3>
			<form action="" method="post" id="f_sign2">
				<div class="inp_line">
					<label>Login:</label>
					<div class="field"><input type="text" class="w_focus" name="name" /></div>
				</div>
				<div class="inp_line">
					<label>Password:</label>
					<div class="field"><input type="text" class="w_focus" name="passw" /></div>
				</div>
				<div class="inp_checkbox">
					<div class="inp_checkbox_in"><a href="#">Forgot your password?</a></div>
					<a href="javascript:;" onclick="document.forms['f_sign2'].submit();" class="button_lnk blue fl def_link"><span>Sign In</span></a> </div>
			</form>
		</div>
	</div>
	
</div>
<div class="theme_settings_wrapper">
	<a href="javascript:void(0)" id="show_settings_button"></a>
	<div class="theme_settings_container">
		<div class="theme_settings_container_top"></div>
		<div class="theme_settings_container_bott"></div>
		<a href="javascript:void(0)" id="hide_settings_button"></a>
		<h3>General skins</h3>
		<select id="skin_type">
			<option value="theme_clean">Clean theme</option>
			<option value="theme_light">Light theme</option>
			<option value="theme_dark">Dark theme</option>
		</select>
		<h3>Background</h3>
		<select id="skin_bg">
			<option value="stretched">Stretched</option>
			<option value="boxed">Boxed</option>
		</select>
		<h3>Color schemes</h3>
		<ul id="color_scheme">
			<li><a href="javascript:void(0)" id="blue" title="Blue">Blue</a></li>
			<li><a href="javascript:void(0)" id="orange" title="Orange">Orange</a></li>
			<li><a href="javascript:void(0)" id="red" title="Red">Red</a></li>
			<li><a href="javascript:void(0)" id="green" title="Green">Green</a></li>
			<li><a href="javascript:void(0)" id="dark_blue" title="Dark Blue">Dark Blue</a></li>
			<li><a href="javascript:void(0)" id="sea_wave" title="Sea Wave">Sea Wave</a></li>
			<li><a href="javascript:void(0)" id="purple" title="Purple">Purple</a></li>
			<li><a href="javascript:void(0)" id="dark_green" title="Dark Green">Dark Green</a></li>
		</ul>
		<div class="boxes_bg">
			<h3>Background Patterns</h3>
			<ul id="pattern_scheme">
				<li><a href="javascript:void(0)" id="wide_cells" title="Wide Cells">Wide Cells</a></li>
				<li><a href="javascript:void(0)" id="wide_diagonal_cells" title="Wide Diagonal Cells">Wide Diagonal Cells</a></li>
				<li><a href="javascript:void(0)" id="huge_cells" title="Huge Cells">Huge Cells</a></li>
				<li><a href="javascript:void(0)" id="diagonal_cells" title="Diagonal cells">Diagonal cells</a></li>
				<li><a href="javascript:void(0)" id="vertical_lines" title="Vertical Lines">Vertical Lines</a></li>
				<li><a href="javascript:void(0)" id="cells" title="Cells">Cells</a></li>
				<li><a href="javascript:void(0)" id="wood" title="Wood [light &amp; clean themes]">Wood [light &amp; clean themes]</a></li>
			</ul>
		</div>
		<h3>Heading Font</h3>
		<select id="skin_font">
			<option value="font_arial">Arial</option>
			<option value="font_droidsans">DroidSans</option>
			<option value="font_oswald">Oswald</option>
			<option value="font_ptsansnarrow">PTSans Narrow</option>
			<option value="font_opensanssemi">OpenSans</option>
		</select>
		<a href="javascript:void(0)" id="reset_styles">Reset styles</a>
	</div>	
</div>


</body>
</html>