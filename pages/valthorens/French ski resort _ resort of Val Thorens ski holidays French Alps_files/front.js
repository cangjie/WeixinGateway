/*!
 * c2is-onetea
 * Front-end Project Quick Init
 * @author C2iS - front-end team
 */

function cookiesConsent() {
    var cookiesConsent = docCookies.getItem("cookiesConsent"), $cookiesBar = $(".cookies-bar");
    null === cookiesConsent ? (cookiesConsent = 0, $cookiesBar.addClass("is-opened"), 
    $cookiesBar.find(".js-cookies-close").on("click", function() {
        $cookiesBar.removeClass("is-opened");
        var expdate = new Date();
        expdate.setTime(expdate.getTime() + 31536e6), cookiesConsent++, setTimeout(function() {
            $cookiesBar.remove();
        }, 1e3), docCookies.setItem("cookiesConsent", cookiesConsent, expdate, "/", null, null);
    })) : $cookiesBar.remove();
}

function getUserAgentElementName(sName) {
    return {
        transEndEventName: {
            transEndEventNames: {
                WebkitTransition: "webkitTransitionEnd",
                MozTransition: "transitionend",
                OTransition: "oTransitionEnd",
                transition: "transitionend"
            }
        }.transEndEventNames[Modernizr.prefixed("transition")]
    }[sName];
}

function responsiveHelper() {
    if (localStorage.getItem("responsive-debug")) {
        var $responsiveHelper = $("<div>");
        $responsiveHelper.addClass("responsive-helper"), $("body").append($responsiveHelper);
        var resizeId;
        $(window).resize(function() {
            $responsiveHelper.addClass("is-visible"), clearTimeout(resizeId), resizeId = setTimeout(doneResizing, 500);
        });
    }
}

function doneResizing() {
    $(".responsive-helper").removeClass("is-visible");
}

function loadCitybreakAccomadationForm() {
    $.ajax({
        url: global.citybreak.url,
        dataType: "script",
        error: function() {
            errorHandler();
        },
        success: function(data, textStatus, jqXHR) {
            if (200 !== jqXHR.status) return console.info("Citybreak error"), void errorHandler();
            skinCitybreakAccomadationForm();
        }
    });
}

function skinCitybreakAccomadationForm() {
    function launchSkinReservedForm() {
        $cbWidget.removeClass("is-loading"), $cbWidget.find(".cb_keyword_input, .cb_childage_input").addClass("form-field"), 
        $cbWidget.find(".cb_keyword_input input").attr({
            readonly: "readonly"
        });
        var $customDatepicker = $(".citybreak_custom_datepicker");
        $cbWidget.find("#cb_accommodationtype").wrap("<div>").parent().addClass("select-wrapper").parent().addClass("form-field"), 
        $cbWidget.find(".cb_checkbox").each(function() {
            var $input = $(this).find("input"), sLabel = $(this).find(".cb_checkbox_lbl").html(), sId = $input.attr("id");
            $(this).find("label").remove(), $(this).addClass("checkbox").append($input), $(this).append('<label for="' + sId + '">' + sLabel + "</label>");
        });
        $("#cb_acc_datepicker_cnt").after($customDatepicker), $(".Citybreak_Button").addClass("btn btn-ghost btn-white"), 
        $cbWidget.find("#cb_numadults1, #cb_numchild1").parent().addClass("panel-numberpicker"), 
        $cbWidget.find("#cb_numadults1").parent().prepend($(".citybreak_custom_adult_select").html()), 
        $cbWidget.find("#cb_numchild1").parent().prepend($(".citybreak_custom_children_select").html()), 
        updatePanelNumberpicker($cbWidget.find("#cb_numadults1")), updatePanelNumberpicker($cbWidget.find("#cb_numchild1")), 
        $cbWidget.find("#cb_accommodationtype").on("change", function() {
            updatePanelNumberpicker($cbWidget.find("#cb_numadults1")), updatePanelNumberpicker($cbWidget.find("#cb_numchild1"));
        }), $cbWidget.closest(".is-sticky").length && $(document.body).trigger("sticky_kit:recalc"), 
        $("body").on("click", ".acheter-search .btn-panel", function() {
            $(".acheter-search").toggleClass("is-closed");
        }), $(".home-search").length && $(".cb_ac_section_accomodationtype").prepend($(".home-search").find(".btn-panel")), 
        $("body").hasClass("socio-pro") ? $("body").on("click", "#CB_SearchButton", function() {
            var nameEtab = $("#reserved-citybreak").find("#cb_ac_searchfield").val();
            dataLayer.push({
                event: "declenche-evenement",
                eventCategory: "engagement",
                eventAction: "sejour-etablissement",
                eventLabel: nameEtab
            });
        }) : $("body").on("click", "#CB_SearchButton", function() {
            var nameEtab = $("#reserved-citybreak").find("#cb_accommodationtype option:selected").text();
            dataLayer.push({
                event: "declenche-evenement",
                eventCategory: "engagement",
                eventAction: "sejour",
                eventLabel: nameEtab
            });
        });
    }
    var idIntervalTestCbLoaded, idTimeOutTestCbLoaded, $cbWidget = $("#citybreak_accommodation_searchform_widget:not(.js-done)");
    $cbWidget.addClass("js-done"), idTimeOutTestCbLoaded = setTimeout(function() {
        console.error("CB not loaded : too long"), clearInterval(idIntervalTestCbLoaded);
    }, 15e3), idIntervalTestCbLoaded = setInterval(function() {
        $cbWidget.children(".Citybreak_engine").length && (clearInterval(idIntervalTestCbLoaded), 
        clearTimeout(idTimeOutTestCbLoaded), launchSkinReservedForm());
    }, 50);
}

function loadCitybreakEventForm() {
    $.ajax({
        url: global.citybreak.url,
        dataType: "script",
        error: function() {
            errorHandler();
        },
        success: function(data, textStatus, jqXHR) {
            if (200 !== jqXHR.status) return console.info("Citybreak error"), void errorHandler();
            skinCitybreakEventForm();
        }
    });
}

function skinCitybreakEventForm() {
    function launchSkinReservedForm() {
        $cbWidget.removeClass("is-loading");
        var $customDatepickerFrom = $(".citybreak_custom_datepicker.dp-from"), $customDatepickerTo = $(".citybreak_custom_datepicker.dp-to"), cpt = 0;
        $cbWidget.find(".cb_radio").each(function() {
            var $input = $(this).find("input"), sLabel = $(this).find(".cb_radio_lbl").html(), sId = $input.attr("id");
            void 0 === sId && (sId = "cd-radio-" + cpt, $input.attr({
                id: sId
            }), cpt++), $(this).find("label").remove(), $(this).addClass("radio").append($input), 
            $(this).append('<label for="' + sId + '">' + sLabel + "</label>");
        });
        $(".cb_ev_section_datepicker").append($customDatepickerFrom), $("#cb_ev_dateto_container").append($customDatepickerTo), 
        $(".Citybreak_Button").addClass("btn btn-ghost btn-white btn-fullwidth"), $cbWidget.closest(".is-sticky").length && $(document.body).trigger("sticky_kit:recalc"), 
        $("body").on("click", "#cb_ev_SearchButton", function() {
            var dateCB = $("#reserved-citybreak").find(".citybreak_custom_datepicker .datepicker").val();
            dataLayer.push({
                event: "declenche-evenement",
                eventCategory: "engagement",
                eventAction: "transfert",
                eventLabel: dateCB
            });
        });
    }
    var idIntervalTestCbLoaded, idTimeOutTestCbLoaded, $cbWidget = $("#citybreak_event_searchform_widget:not(.js-done)");
    $cbWidget.addClass("js-done"), idTimeOutTestCbLoaded = setTimeout(function() {
        console.error("CB not loaded : too long"), clearInterval(idIntervalTestCbLoaded);
    }, 15e3), idIntervalTestCbLoaded = setInterval(function() {
        $cbWidget.children(".Citybreak_engine").length && (clearInterval(idIntervalTestCbLoaded), 
        clearTimeout(idTimeOutTestCbLoaded), launchSkinReservedForm());
    }, 50);
}

function initTilesPosition() {
    if (!bIsPhone) {
        var $tiles = $('[data-show="on-scroll"]'), iViewTop = iWindowScrollTop, iViewBottom = iViewTop + $(window).height();
        $tiles.each(function(i) {
            var $tile = $(this);
            ($tile.offset().top > iViewBottom || $tile.closest(".events-month:not(.is-active)").length) && $tile.addClass("tile-not-in-view has-transition");
        });
    }
}

function checkTilesPosition() {
    if (!bIsPhone) {
        var $tilesNotInView = $(".tile-not-in-view");
        if (!$tilesNotInView.length) return !1;
        var iViewTop = iWindowScrollTop, iViewBottom = iViewTop + $(window).height(), iCpt = 0, aTilesNotInView = [];
        $tilesNotInView.each(function(i) {
            var $currentTile = $(this), iCurrentTileScrollTop = $currentTile.offset().top;
            $currentTile.height();
            $currentTile.closest(".events-month:not(.is-active)").length && !$currentTile.closest(".events-month.is-active").length || (iCurrentTileScrollTop < iViewTop ? $currentTile.removeClass("tile-not-in-view has-transition") : iCurrentTileScrollTop < iViewBottom && ($currentTile.addClass("tile-transition-delay-" + (200 * iCpt + 100)), 
            $currentTile.removeClass("tile-not-in-view"), iCpt++, aTilesNotInView.push($currentTile)));
        }), setTimeout(function() {
            $.each(aTilesNotInView, function(key, $tile) {
                $tile.removeClass("has-transition");
            });
        }, 200 * aTilesNotInView.length + 1e3);
    }
}

var $window = $(window), iWindowScrollTop = 0, bOnlyInte = $("html").hasClass("onlyInte"), bIsPhone = $("html").hasClass("is-phone"), bIsTablet = $("html").hasClass("is-tablet"), bIsDesktop = $("html").hasClass("is-desktop"), bIsIos = $("html").hasClass("is-ios"), bStickySecondaryNav = $(".is-sticky-secondary-nav").length, iDirectAccessHeight = $(".direct-access").height(), hinclude;

if (function() {
    "use strict";
    hinclude = {
        classprefix: "include_",
        set_content_async: function(element, req) {
            4 === req.readyState && (200 !== req.status && 304 !== req.status || (element.innerHTML = req.responseText, 
            $("body").trigger("hinclude-loaded", {
                element: $(element),
                name: $(element).data("name")
            })), element.className = hinclude.classprefix + req.status);
        },
        buffer: [],
        set_content_buffered: function(element, req) {
            4 === req.readyState && (hinclude.buffer.push([ element, req ]), hinclude.outstanding -= 1, 
            0 === hinclude.outstanding && hinclude.show_buffered_content());
        },
        show_buffered_content: function() {
            for (;hinclude.buffer.length > 0; ) {
                var include = hinclude.buffer.pop();
                200 !== include[1].status && 304 !== include[1].status || (include[0].innerHTML = include[1].responseText, 
                $("body").trigger("hinclude-loaded", {
                    element: $(include[0]),
                    name: $(include[0]).data("name")
                })), include[0].className = hinclude.classprefix + include[1].status;
            }
        },
        outstanding: 0,
        includes: [],
        run: function() {
            var i = 0, mode = this.get_meta("include_mode", "buffered"), callback = function(element, req) {};
            if (this.includes = document.getElementsByTagName("hx:include"), 0 === this.includes.length && (this.includes = document.getElementsByTagName("include")), 
            "async" === mode) callback = this.set_content_async; else if ("buffered" === mode) {
                callback = this.set_content_buffered;
                var timeout = 1e3 * this.get_meta("include_timeout", 2.5);
                setTimeout(hinclude.show_buffered_content, timeout);
            }
            for (i; i < this.includes.length; i += 1) this.include(this.includes[i], this.includes[i].getAttribute("src"), callback);
        },
        include: function(element, url, incl_cb) {
            if ("data" === url.substring(0, url.indexOf(":")).toLowerCase()) {
                var data = decodeURIComponent(url.substring(url.indexOf(",") + 1, url.length));
                element.innerHTML = data, $("body").trigger("hinclude-loaded", {
                    element: $(element),
                    name: $(element).data("name")
                });
            } else {
                var req = !1;
                if (window.XMLHttpRequest) try {
                    req = new XMLHttpRequest();
                } catch (e1) {
                    req = !1;
                } else if (window.ActiveXObject) try {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e2) {
                    req = !1;
                }
                if (req) {
                    this.outstanding += 1, req.onreadystatechange = function() {
                        incl_cb(element, req);
                    };
                    try {
                        req.open("GET", url, !0), req.send("");
                    } catch (e3) {
                        this.outstanding -= 1, alert("Include error: " + url + " (" + e3 + ")");
                    }
                }
            }
        },
        refresh: function(element_id) {
            var i = 0, callback = (this.get_meta("include_mode", "buffered"), function(element, req) {});
            for (callback = this.set_content_buffered, i; i < this.includes.length; i += 1) this.includes[i].getAttribute("id") === element_id && this.include(this.includes[i], this.includes[i].getAttribute("src"), callback);
        },
        get_meta: function(name, value_default) {
            var m = 0, metas = document.getElementsByTagName("meta");
            for (m; m < metas.length; m += 1) {
                if (metas[m].getAttribute("name") === name) return metas[m].getAttribute("content");
            }
            return value_default;
        },
        addDOMLoadEvent: function(func) {
            if (!window.__load_events) {
                var init = function() {
                    var i = 0;
                    if (!hinclude.addDOMLoadEvent.done) {
                        for (hinclude.addDOMLoadEvent.done = !0, window.__load_timer && (clearInterval(window.__load_timer), 
                        window.__load_timer = null), i; i < window.__load_events.length; i += 1) window.__load_events[i]();
                        window.__load_events = null;
                    }
                };
                document.addEventListener && document.addEventListener("DOMContentLoaded", init, !1), 
                /WebKit/i.test(navigator.userAgent) && (window.__load_timer = setInterval(function() {
                    /loaded|complete/.test(document.readyState) && init();
                }, 10)), window.onload = init, window.__load_events = [];
            }
            window.__load_events.push(func);
        }
    }, hinclude.addDOMLoadEvent(function() {
        hinclude.run();
    });
}(), $bannerVideo = $("#bannerVideo"), $bannerVideoWrapper = $(".banner-bg-video"), 
window.ratio = 16 / 9, $bannerVideo.length > 0) {
    var tag = document.createElement("script");
    tag.src = "//www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName("script")[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    var oVideoOptions = {
        autoplay: !1,
        sound: !0
    };
    $bannerVideoWrapper.data("options") && $.extend(oVideoOptions, $bannerVideoWrapper.data("options"));
    var player, onYouTubeIframeAPIReady = function() {
        player = new YT.Player("bannerVideo", {
            events: {
                onReady: onPlayerReady
            }
        });
    }, onPlayerReady = function() {
        bIsDesktop && oVideoOptions.autoplay && (player.playVideo(), $bannerVideoWrapper.addClass("is-playing")), 
        player.mute();
    };
    $("body").on("click", ".banner-video-off", function() {
        bIsDesktop && player.playVideo(), $(".banner-bg-video").addClass("is-playing");
    });
    var resizeVt = function() {
        var pWidth, pHeight, oHeader = ($(window).height(), $("body").find("header.header")), oAside = (oHeader.outerHeight(), 
        $("body").find(".aside")), width = (oAside.outerWidth(), $(".banner-bg-video").width()), height = $(".banner-bg-video").height();
        width / ratio < height ? (pWidth = Math.ceil(height * ratio), $bannerVideo.width(pWidth).height(height).css({
            left: (width - pWidth) / 2,
            top: 0
        })) : (pHeight = Math.ceil(width / ratio), $bannerVideo.width(width).height(pHeight).css({
            left: 0,
            top: (height - pHeight) / 2
        }));
    };
    resizeVt(), $(window).on("resize", function() {
        resizeVt();
    });
}

var accountSetup = function() {
    function postAccountForm($form) {
        $.post($form.attr("action"), $form.serialize());
    }
    var $body = $("body");
    $body.on("change", ".settings-periodes input", function() {
        var $radio = $(this), sTarget = $radio.attr("id");
        $("." + sTarget).removeClass("is-hidden").siblings().addClass("is-hidden"), $('[data-settings-day-target="' + sTarget + '"]').removeClass("is-hidden").siblings(".icon").addClass("is-hidden");
    }), $body.on("submit", "form.user-settings-form", function(event) {
        event.preventDefault(), postAccountForm($(this));
    });
    var requestTimer = null;
    $body.on("change", "form.user-settings-form input", function(event) {
        var $form = $(this).closest("form");
        clearTimeout(requestTimer), requestTimer = setTimeout(function() {
            postAccountForm($form);
        }, 250);
    });
}, compassAnimation = function() {
    function animateCompass($compass) {
        var $aiguille = $compass.find(".aiguille"), iDirection = $aiguille.data("direction");
        $aiguille.css({
            transform: "rotate(" + iDirection + "deg)"
        });
    }
    $(".js-compass-animate").length && $(".js-compass-animate").each(function() {
        var $currentCompass = $(this), isTriggered = !1, sy = $(window).scrollTop(), iCompassOffset = $currentCompass.offset().top, iWindowHeight = $(window).height();
        sy >= iCompassOffset - iWindowHeight && !1 === isTriggered && (isTriggered = !0, 
        animateCompass($currentCompass)), $(window).on("scroll", function() {
            sy = $(window).scrollTop(), iCompassOffset = $currentCompass.offset().top, iWindowHeight = $(window).height(), 
            sy >= iCompassOffset - iWindowHeight && !1 === isTriggered && (isTriggered = !0, 
            animateCompass($currentCompass));
        });
    });
}, docCookies = {
    getItem: function(sKey) {
        return sKey ? decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1")) || null : null;
    },
    setItem: function(sKey, sValue, vEnd, sPath, sDomain, bSecure) {
        if (!sKey || /^(?:expires|max\-age|path|domain|secure)$/i.test(sKey)) return !1;
        var sExpires = "";
        if (vEnd) switch (vEnd.constructor) {
          case Number:
            sExpires = vEnd === 1 / 0 ? "; expires=Fri, 31 Dec 9999 23:59:59 GMT" : "; max-age=" + vEnd;
            break;

          case String:
            sExpires = "; expires=" + vEnd;
            break;

          case Date:
            sExpires = "; expires=" + vEnd.toUTCString();
        }
        return document.cookie = encodeURIComponent(sKey) + "=" + encodeURIComponent(sValue) + sExpires + (sDomain ? "; domain=" + sDomain : "") + (sPath ? "; path=" + sPath : "") + (bSecure ? "; secure" : ""), 
        !0;
    },
    removeItem: function(sKey, sPath, sDomain) {
        return !!this.hasItem(sKey) && (document.cookie = encodeURIComponent(sKey) + "=; expires=Thu, 01 Jan 1970 00:00:00 GMT" + (sDomain ? "; domain=" + sDomain : "") + (sPath ? "; path=" + sPath : ""), 
        !0);
    },
    hasItem: function(sKey) {
        return !!sKey && new RegExp("(?:^|;\\s*)" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=").test(document.cookie);
    },
    keys: function() {
        for (var aKeys = document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, "").split(/\s*(?:\=[^;]*)?;\s*/), nLen = aKeys.length, nIdx = 0; nIdx < nLen; nIdx++) aKeys[nIdx] = decodeURIComponent(aKeys[nIdx]);
        return aKeys;
    }
}, counterAnimation = function() {
    function animateCounters() {
        var $counter = $("[data-counter]");
        $counter.css({
            opacity: 1
        }), $counter.each(function() {
            $(this).prop("Counter", 0).animate({
                Counter: $(this).text()
            }, {
                duration: 3e3,
                easing: "swing",
                step: function(now) {
                    $(this).text(Math.ceil(now));
                }
            });
        });
    }
    $("[data-counter]").length && $("[data-counter]").each(function() {
        var $currentCounter = $(this), isTriggered = !1, sy = $(window).scrollTop(), iCounterOffset = $currentCounter.offset().top, iWindowHeight = $(window).height();
        sy >= iCounterOffset - iWindowHeight && !1 === isTriggered && (isTriggered = !0, 
        animateCounters()), $(window).on("scroll", function() {
            sy = $(window).scrollTop(), iCounterOffset = $currentCounter.offset().top, iWindowHeight = $(window).height(), 
            sy >= iCounterOffset - iWindowHeight && !1 === isTriggered && (isTriggered = !0, 
            animateCounters());
        });
    });
}, oDefaultsDatepikerSettings = {
    autoSize: !0,
    dateFormat: settingsLocalization.sDateFormat,
    numberOfMonths: 1,
    maxDate: null,
    minDate: null
}, iOneSec = 1e3, iOneMin = 60 * iOneSec, iOneHour = 60 * iOneMin, iOneDay = 24 * iOneHour, updatePanelDatepicker = function($datepicker) {
    if ($datepicker.closest(".citybreak_custom_datepicker").length) {
        var sDate = $datepicker.val();
        $datepicker.closest(".start-date").length ? $("#cb_form_datefrom").val(sDate) : $("#cb_form_dateto").val(sDate);
    }
    var months = $datepicker.datepicker("option", "monthNames"), mydatepicked = $datepicker.datepicker("getDate"), selectedMonthName = months[mydatepicked.getMonth()], selectedDate = ("0" + mydatepicked.getDate()).slice(-2), selectedYear = mydatepicked.getFullYear();
    $datepicker.closest(".panel-datepicker").find(".date").html(selectedDate), $datepicker.closest(".panel-datepicker").find(".month").html(selectedMonthName), 
    $(".panel-datepicker .year").length && $datepicker.closest(".panel-datepicker").find(".year").html(selectedYear);
};

$(".panel-datepicker").length && $(".panel-datepicker .datepicker").each(function() {
    var oDpOptions = {};
    if ($(this).data("options")) {
        var opt = $(this).data("options");
        "string" == typeof opt && (opt = JSON.parse(opt)), $.extend(oDpOptions, opt);
    }
    $(this).datepicker($.extend({}, oDefaultsDatepikerSettings, oDpOptions)), updatePanelDatepicker($(this)), 
    $(this).on("change", function() {
        if (updatePanelDatepicker($(this)), $(this).closest(".start-date").length) {
            var $startDatepicker = $(this), $endDatepicker = $startDatepicker.closest(".start-date").siblings(".end-date").find(".datepicker"), date = $startDatepicker.datepicker("getDate"), iDateTime = date.getTime(), dNewDate = new Date(iDateTime + 7 * iOneDay), dNewMinDate = new Date(iDateTime + iOneDay);
            $endDatepicker.datepicker("setDate", dNewDate), $endDatepicker.datepicker("option", "minDate", dNewMinDate), 
            updatePanelDatepicker($endDatepicker);
        }
    });
});

var ellipsisText = function() {
    setTimeout(function() {
        $(".has-ellipsis:not(.js-done)").addClass("js-done").dotdotdot({
            watch: "window"
        });
    }, 0);
}, manageEventsList = function() {
    $("[data-original]").each(function() {
        $(this).is("img") ? $(this).attr("src", $(this).data("original")) : $(this).css("background-image", "url(" + $(this).data("original") + ")");
    }), $(this).css("display", "block"), $(".events-month-nav li").on("click", function() {
        if (!$(this).hasClass("is-active")) {
            $(this).addClass("is-active").siblings(".is-active").removeClass("is-active");
            var $newMonth = $($(this).data("target")), $currentMonth = $newMonth.siblings(".is-active");
            $("#list-events");
            document.goTo({
                target: "#list-events"
            }), bIsPhone ? ($newMonth.addClass("is-active"), $currentMonth.removeClass("is-active").children().addClass("tile-filter-not-in-view"), 
            setTimeout(function() {
                $newMonth.children().removeClass("tile-filter-not-in-view");
            }, 300)) : ($newMonth.addClass("is-active").children().addClass("has-transition tile-filter-not-in-view").each(function() {
                this.className = $.grep(this.className.split(" "), function(el) {
                    return !/^tile-transition-delay-/.test(el);
                }).join(" ");
            }), $currentMonth.removeClass("is-active").children().addClass("has-transition tile-filter-not-in-view").each(function() {
                this.className = $.grep(this.className.split(" "), function(el) {
                    return !/^tile-transition-delay-/.test(el);
                }).join(" ");
            }), $(document.body).trigger("sticky_kit:recalc"), setTimeout(function() {
                $newMonth.children().removeClass("tile-filter-not-in-view").addClass("tile-not-in-view"), 
                setTimeout(function() {
                    checkTilesPosition(), $currentMonth.children().removeClass("tile-filter-not-in-view").addClass("tile-not-in-view");
                }, 10);
            }, 600)), initAndAjax();
        }
    }), $(".btn-next-month").on("click", function() {
        var $nextLi = $(".events-month-nav .is-active").next("li");
        if ($nextLi.trigger("click"), bIsPhone) {
            var iNextLiLeft = $nextLi.offset().left, iCurrentScrollLeft = $(".events-month-nav").scrollLeft();
            $(".events-month-nav").scrollLeft(iNextLiLeft + iCurrentScrollLeft - ($window.width() / 2 - 15));
        }
    });
};

$.extend($.fn, {
    examplePrototypeFunction: function(options) {
        $(this).each(function() {});
    }
});

var exampleSimpleFunction = function() {};

!function($, window, document, undefined) {
    "use strict";
    function ConstructorPluginName(element, options) {
        var self = this;
        self.element = element, self.$element = $(self.element), self.settings = $.extend({}, defaults, options), 
        self.$element.data("custom-plugin-options") !== undefined && $.extend(self.settings, self.$element.data("custom-plugin-options")), 
        self._settings = $.extend({}, self.settings), self._defaults = defaults, self._name = pluginName, 
        self._init();
    }
    var pluginName = "myCustomPlugin", defaults = {
        propertyName: "value",
        cptStart: 0
    };
    $.extend(ConstructorPluginName.prototype, {
        _init: function() {
            var self = this;
            self._yourOtherFunction("Custom plugin Ready :)<br><br>"), self._bindUiAction(), 
            self._updateCpt();
        },
        reset: function() {
            var self = this;
            self.settings = $.extend({}, self._settings), self._updateCpt();
        },
        destroy: function() {
            var self = this;
            self.$element.find("strong").empty(), self.$element.find("span").empty(), self._unbindUiAction(), 
            $.data(self.element, "plugin_" + pluginName, null);
        },
        forceValue: function(i) {
            var self = this;
            self.settings.cptStart = i, self._updateCpt();
        },
        _bindUiAction: function() {
            var self = this;
            self.$element.find("button").on("click.plugin_" + pluginName, function() {
                self.settings.cptStart++, self._updateCpt();
            });
        },
        _unbindUiAction: function() {
            this.$element.find("button").off("click.plugin_" + pluginName);
        },
        _yourOtherFunction: function(str) {
            this.$element.find("strong").html(str);
        },
        _updateCpt: function() {
            var self = this;
            self.$element.find("span").html(self.settings.cptStart);
        }
    }), $.fn[pluginName] = function(options) {
        var args = arguments;
        if (options === undefined || "object" == typeof options) return this.each(function() {
            $.data(this, "plugin_" + pluginName) || $.data(this, "plugin_" + pluginName, new ConstructorPluginName(this, options));
        });
        if ("string" == typeof options && "_" !== options[0]) {
            var returns;
            return this.each(function() {
                var instance = $.data(this, "plugin_" + pluginName);
                instance instanceof ConstructorPluginName && "function" == typeof instance[options] && (returns = instance[options].apply(instance, Array.prototype.slice.call(args, 1)));
            }), returns !== undefined ? returns : this;
        }
    };
}(jQuery, window, document);

var loadFatmap = function() {
    var script = document.createElement("script");
    script.type = "text/javascript", script.id = "fatmap-load-script", script.src = "//map-assets.fatmap.com/js/fatmap.0.0.8.js?callback=initFatmap", 
    document.body.appendChild(script);
};

window.initFatmap = function() {
    var initView = {
        position: {
            x: -5788.699549420044,
            y: -4923.411687482127,
            z: 5245.1341404050545
        },
        target: {
            x: -5787.829308034689,
            y: -4923.184202277327,
            z: 5244.697184609526
        }
    }, myExampleMap = fatmap.loadMap({
        name: "trois_vallees",
        container: document.getElementById("my-fatmap"),
        cameraView: initView,
        liveStatus: !1,
        shouldDebug: !0,
        onLoadProgress: function(percentage) {},
        onLoadComplete: function() {
            myExampleMap.getLabelManager(), myExampleMap.getLiftManager(), myExampleMap.getPisteManager();
            setTimeout(function() {
                $(".popin-page-content").removeClass("loading"), setTimeout(function() {
                    $(".popin-page-content").children(".loader").remove();
                }, 1e3);
            }, 2e3), $(".js-map-get-view").on("click", function() {
                myExampleMap.getCurrentView();
            });
        }
    });
};

var filteredList = function() {
    function reorderItemSummerFirst(arrayToOrder) {
        var aSummerItems = [], aNotSummerItems = [];
        return arrayToOrder.forEach(function(item) {
            $(item).find(".card").hasClass("opened-in-summer") ? aSummerItems.push(item) : aNotSummerItems.push(item);
        }), aSummerItems.concat(aNotSummerItems);
    }
    function filteringItems() {
        var $filteredList = $(".js-filtered-list"), $filteredMap = $filteredList.siblings(".js-filtered-map"), aActiveFilters = [];
        $(".js-filters .js-filter:not(.off):not(.summer)").each(function() {
            aActiveFilters.push($(this).attr("data-filter"));
        });
        var aListItemsFiltered = [];
        aListItems.slice(0).forEach(function(item, itemIndex, object) {
            aActiveFilters.forEach(function(filter) {
                $(item).hasClass(filter) && (aListItemsFiltered.push(item), object[itemIndex] = "");
            });
        }), 0 === aListItemsFiltered.length && (aListItemsFiltered = aListItems.slice(0)), 
        $(".js-filters .js-filter.summer").hasClass("off") ? ($filteredList.removeClass("show-summer"), 
        $filteredMap.removeClass("show-summer")) : (aListItemsFiltered = reorderItemSummerFirst(aListItemsFiltered), 
        $filteredList.addClass("show-summer"), $filteredMap.addClass("show-summer")), $filteredList.find("[data-show]").addClass("has-transition tile-filter-not-in-view").each(function() {
            this.className = $.grep(this.className.split(" "), function(el) {
                return !/^tile-transition-delay-/.test(el);
            }).join(" ");
        }), $filteredMap.length && $(".js-filtered-map").hasClass("is-active") && $filteredMap.find(".interactiveHtmlMap").manageInteractiveMapTiles("refreshFilteredMarkers", aListItemsFiltered), 
        setTimeout(function() {
            $filteredList.find(".has-ellipsis").removeClass("js-done").trigger("destroy"), $filteredList.empty(), 
            $isotopeFilteredList.isotope("destroy"), aListItemsFiltered.forEach(function(item) {
                $filteredList.append(item);
            }), setTimeout(function() {
                $filteredList.find("[data-show]").addClass("has-transition tile-not-in-view").removeClass("tile-filter-not-in-view"), 
                $isotopeFilteredList = launchIsotop(), initAndAjax(), ellipsisText(), checkTilesPosition();
            }, 0);
        }, 600);
    }
    $("body").on("click", ".js-toggle-filters", function() {
        $(this).closest(".filters").toggleClass("is-opened"), $(".js-filtered-list, .js-filtered-wrapper").toggleClass("is-slided");
    }), $(document).on("click", function(event) {
        $(event.target).closest(".filters").length || ($(".filters").removeClass("is-opened"), 
        $(".js-filtered-list, .js-filtered-wrapper").removeClass("is-slided"));
    }), $("body").on("click", ".toggle-list-map button", function() {
        $(this).toggleClass("is-active").siblings(".icon").toggleClass("is-active"), $(this).closest(".js-filtered-wrapper").find(".js-filtered-list, .js-filtered-map").toggleClass("is-active"), 
        $(".js-filtered-map").hasClass("is-active") && filteringItems(), $(".js-filters-top").length && document.goTo({
            target: ".js-filters-top"
        });
    });
    var launchIsotop = function() {
        return $(".js-filtered-list").isotope({
            itemSelector: ".list-item",
            masonry: {
                gutter: 15
            }
        });
    }, $isotopeFilteredList = launchIsotop();
    setTimeout(function() {
        $isotopeFilteredList.isotope("layout");
    }, 1e3), $isotopeFilteredList.isotope("on", "arrangeComplete", function(filteredItems) {
        checkTilesPosition();
    });
    var aListItems = [];
    $(".js-filtered-list .list-item").each(function() {
        var $clone = $(this).clone();
        $clone.find(".js-done").removeClass("js-done"), aListItems.push($clone);
    }), filteringItems(), $("body").on("click", ".js-filters .js-filter", function() {
        $(this).toggleClass("off"), filteringItems(), $(".js-filters-top").length && document.goTo({
            target: ".js-filters-top"
        });
    }), $("body").on("click", ".social-wall-nav.js-filters .js-filter", function() {
        var pushTitle = $(this).attr("data-balloon");
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "filtre_sociaux",
            eventLabel: pushTitle
        });
    }), $("body").on("click", ".js-filtered-list .card .js-open-card-tools", function() {
        setTimeout(function() {
            $isotopeFilteredList.isotope("layout");
        }, 0);
    });
}, activitiesFilteredList = function() {
    function filteringItems() {
        var $filteredList = $(".js-activities-filtered-list"), aActiveFilters = [];
        $(".js-filters .js-filter:not(.off)").each(function() {
            aActiveFilters.push($(this).attr("data-filter"));
        });
        var aListItemsFiltered = [];
        aListItems.slice(0).forEach(function(item, itemIndex, object) {
            aActiveFilters.forEach(function(filter) {
                $(item).hasClass(filter) && (aListItemsFiltered.push(item), object[itemIndex] = "");
            });
        }), 0 === aListItemsFiltered.length && (aListItemsFiltered = aListItems.slice(0)), 
        $filteredList.find("[data-show]").addClass("has-transition tile-filter-not-in-view").each(function() {
            this.className = $.grep(this.className.split(" "), function(el) {
                return !/^tile-transition-delay-/.test(el);
            }).join(" ");
        }), setTimeout(function() {
            $filteredList.find(".has-ellipsis").removeClass("js-done").trigger("destroy"), $filteredList.empty(), 
            aListItemsFiltered.forEach(function(item) {
                $filteredList.append(item);
            }), setTimeout(function() {
                $filteredList.find("[data-show]").addClass("has-transition tile-not-in-view").removeClass("tile-filter-not-in-view"), 
                initAndAjax(), ellipsisText(), checkTilesPosition();
            }, 0);
        }, 600);
    }
    $("body").on("click", ".js-toggle-filters", function() {
        $(this).closest(".filters").toggleClass("is-opened"), $(".js-activities-filtered-list").toggleClass("is-slided");
    }), $(document).on("click", function(event) {
        $(event.target).closest(".filters").length || ($(".filters").removeClass("is-opened"), 
        $(".js-activities-filtered-list").removeClass("is-slided"));
    });
    var aListItems = [];
    $(".js-activities-filtered-list .list-item").each(function() {
        var $clone = $(this).clone();
        $clone.removeClass("js-done"), aListItems.push($clone);
    }), filteringItems(), $("body").on("click", ".js-filters .js-filter", function() {
        $(this).toggleClass("off"), filteringItems(), $(".js-filters-top").length && document.goTo({
            target: ".js-filters-top"
        });
    });
}, aFilters = [], homeActuFilteredList = function() {
    var $homeActuFilteredList = $(".js-home-actu-filtered-list");
    $homeActuFilteredList.data("pages", 1), document.getElementsByName("homepage-content-more") && $("body").on("click", "#homepage-content-more", function() {
        $homeActuFilteredList.data("pages", $homeActuFilteredList.data("pages") + 1), refreshHomeActuList({
            emptyContent: !1
        });
    }), $("body").on("click", ".js-home-actu-filters .js-filter", function() {
        var pushTitle = $(this).attr("data-balloon");
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "filtre_actu",
            eventLabel: pushTitle
        }), $(this).toggleClass("off"), aFilters = [], $(".js-home-actu-filters .js-filter:not(.off)").each(function() {
            aFilters.push($(this).data("form-filter"));
        }), refreshHomeActuList();
    });
}, refreshHomeActuList = function(options) {
    var $homeActuFilteredList = $(".js-home-actu-filtered-list"), sActuPathAjax = $homeActuFilteredList.data("path-ajax"), htmlContent = "", defaultOptions = {
        emptyContent: !0
    }, settings = $.extend({}, defaultOptions, options || {});
    settings.emptyContent && ($(".js-filters-top").length && document.goTo({
        target: ".js-filters-top"
    }), $(".js-home-actu-filtered-list, .js-home-actu-filters").addClass("is-loading"), 
    $homeActuFilteredList.find("[data-show]").addClass("has-transition tile-filter-not-in-view").each(function() {
        this.className = $.grep(this.className.split(" "), function(el) {
            return !/^tile-transition-delay-/.test(el);
        }).join(" ");
    }));
    var aPromises = [];
    settings.emptyContent && aPromises.push(function() {
        var promiseEndHide = new $.Deferred();
        return setTimeout(function() {
            $homeActuFilteredList.empty(), promiseEndHide.resolve();
        }, 600), promiseEndHide.promise();
    }()), aPromises.push(function() {
        var promiseAjax = new $.Deferred();
        return $.ajax({
            type: "GET",
            url: bOnlyInte ? sActuPathAjax : sActuPathAjax.replace("--filters--", aFilters.join(",")).replace("--pages--", $homeActuFilteredList.data("pages")).replace(new RegExp("[/]*$"), ""),
            dataType: bOnlyInte ? "html" : "json"
        }).done(function(data) {
            htmlContent = bOnlyInte ? data : data.contentHtml, promiseAjax.resolve();
        }).fail(function(jqXHR, textStatus) {
            console.error("error loadAjaxAction"), console.error(jqXHR), console.error(textStatus);
        }).always(function() {}), promiseAjax.promise();
    }()), $.when.apply(null, aPromises).then(function() {
        $homeActuFilteredList.append(htmlContent), $homeActuFilteredList.find("[data-show]").addClass("has-transition " + (bIsPhone ? "tile-filter-not-in-view" : "tile-not-in-view")), 
        initAndAjax(), ellipsisText(), bIsPhone ? setTimeout(function() {
            $homeActuFilteredList.find("[data-show]").removeClass("tile-filter-not-in-view");
        }, 100) : checkTilesPosition(), $(".js-home-actu-filtered-list, .js-home-actu-filters").removeClass("is-loading");
    });
}, manageFormFields = function() {
    if ($("body").on("input", ".has-btn-clear input", function() {
        "" !== $(this).val() ? $(this).closest(".has-btn-clear").addClass("is-not-empty") : $(this).closest(".has-btn-clear").removeClass("is-not-empty");
    }), $("body").on("click", ".btn-clear", function() {
        $(this).closest(".has-btn-clear").removeClass("is-not-empty").find("input").val("").trigger("change").trigger("input").trigger("focus");
    }), $(".settings-radio-icon").length && $(".settings-radio-icon .radio-icon input").on("change", function() {
        var $input = $(this), $label = $("[for=" + $input.attr("id") + "]"), sLabel = $label.children("span").html(), $target = $("." + $input.closest(".settings-radio-icon").attr("id"));
        $target.length && $target.html(sLabel);
    }), $(".field-geocoding").length) {
        var geo = {
            position: null,
            address: null,
            state: 0
        }, $fieldGeocoding = $(".field-geocoding"), $btnLocation = $fieldGeocoding.find(".icon"), $inputLocation = $fieldGeocoding.find("input"), geolocationSuccess = function(position) {
            geo.position = position, geo.state = 1, $btnLocation.addClass("is-hidden"), $fieldGeocoding.find(".is-allowed").removeClass("is-hidden");
        }, geolocationError = function(error) {
            console.warn("geolocationError : ", error), geo.state = error.code + 1, $btnLocation.addClass("is-hidden"), 
            $fieldGeocoding.find("." + (1 == error.code ? "is-denied" : "has-error")).removeClass("is-hidden");
        };
        navigator.geolocation ? navigator.geolocation.getCurrentPosition(geolocationSuccess, geolocationError) : $fieldGeocoding.removeClass("has-icon").find(".icon").remove(), 
        $btnLocation.on("click", function() {
            1 === geo.state && $.ajax({
                url: "https://maps.googleapis.com/maps/api/geocode/json",
                method: "get",
                data: {
                    latlng: geo.position.coords.latitude + "," + geo.position.coords.longitude,
                    key: settingsGlobal.sGoogleApiKey
                }
            }).done(function(data) {
                $btnLocation.addClass("is-hidden"), "OK" == data.status ? (geo.address = data.results[0].formatted_address, 
                $inputLocation.val(geo.address).trigger("change").trigger("input").trigger("focus"), 
                $fieldGeocoding.find(".is-located").removeClass("is-hidden")) : (geo.address = null, 
                $fieldGeocoding.find(".has-error").removeClass("is-hidden"));
            }).fail(function(error) {
                console.warn("geocode ajax error!", error);
            }).complete(function() {});
        });
        $inputLocation.on("input", function() {
            var $input = $(this);
            1 === geo.state && ($input.val() == geo.address ? $fieldGeocoding.find(".is-located").removeClass("is-hidden").siblings(".is-allowed").addClass("is-hidden") : $fieldGeocoding.find(".is-allowed").removeClass("is-hidden").siblings(".is-located").addClass("is-hidden"));
            var $target = $("." + $input.attr("id"));
            $target.length && $target.html($input.val());
        });
    }
};

!function() {
    "use strict";
    var isCommonjs = "undefined" != typeof module && module.exports, keyboardAllowed = "undefined" != typeof Element && "ALLOW_KEYBOARD_INPUT" in Element, fn = function() {
        for (var val, valLength, fnMap = [ [ "requestFullscreen", "exitFullscreen", "fullscreenElement", "fullscreenEnabled", "fullscreenchange", "fullscreenerror" ], [ "webkitRequestFullscreen", "webkitExitFullscreen", "webkitFullscreenElement", "webkitFullscreenEnabled", "webkitfullscreenchange", "webkitfullscreenerror" ], [ "webkitRequestFullScreen", "webkitCancelFullScreen", "webkitCurrentFullScreenElement", "webkitCancelFullScreen", "webkitfullscreenchange", "webkitfullscreenerror" ], [ "mozRequestFullScreen", "mozCancelFullScreen", "mozFullScreenElement", "mozFullScreenEnabled", "mozfullscreenchange", "mozfullscreenerror" ], [ "msRequestFullscreen", "msExitFullscreen", "msFullscreenElement", "msFullscreenEnabled", "MSFullscreenChange", "MSFullscreenError" ] ], i = 0, l = fnMap.length, ret = {}; i < l; i++) if ((val = fnMap[i]) && val[1] in document) {
            for (i = 0, valLength = val.length; i < valLength; i++) ret[fnMap[0][i]] = val[i];
            return ret;
        }
        return !1;
    }(), screenfull = {
        request: function(elem) {
            var request = fn.requestFullscreen;
            elem = elem || document.documentElement, /5\.1[\.\d]* Safari/.test(navigator.userAgent) ? elem[request]() : elem[request](keyboardAllowed && Element.ALLOW_KEYBOARD_INPUT);
        },
        exit: function() {
            document[fn.exitFullscreen]();
        },
        toggle: function(elem) {
            this.isFullscreen ? this.exit() : this.request(elem);
        },
        onchange: function() {},
        onerror: function() {},
        raw: fn
    };
    if (!fn) return void (isCommonjs ? module.exports = !1 : window.screenfull = !1);
    Object.defineProperties(screenfull, {
        isFullscreen: {
            get: function() {
                return !!document[fn.fullscreenElement];
            }
        },
        element: {
            enumerable: !0,
            get: function() {
                return document[fn.fullscreenElement];
            }
        },
        enabled: {
            enumerable: !0,
            get: function() {
                return !!document[fn.fullscreenEnabled];
            }
        }
    }), document.addEventListener(fn.fullscreenchange, function(e) {
        screenfull.onchange.call(screenfull, e);
    }), document.addEventListener(fn.fullscreenerror, function(e) {
        screenfull.onerror.call(screenfull, e);
    }), isCommonjs ? module.exports = screenfull : window.screenfull = screenfull;
}();

var transEndEventName = getUserAgentElementName("transEndEventName");

$.extend($.easing, {
    easeOutExpo: function(x, t, b, c, d) {
        return t == d ? b + c : c * (1 - Math.pow(2, -10 * t / d)) + b;
    }
}), $("body").on("click", ".js-go-to", function(event) {
    event.preventDefault();
    var sTarget = $(this).data("go-to") ? $(this).data("go-to") : $(this).attr("href");
    document.goTo({
        target: sTarget
    });
}), document.goTo = function(options) {
    var goToDeferred = new $.Deferred();
    if ("object" == typeof options) {
        var defaultOptions = {
            target: null,
            durationMax: 1e3,
            distanceMax: 1e3
        }, settings = $.extend({}, defaultOptions, options), iTargetTop = 0, iHeaderHeight = bIsPhone ? $(".header").height() + 15 : 0;
        if ("string" == typeof settings.target) iTargetTop = $(settings.target).offset().top - iHeaderHeight; else if ("number" == typeof settings.target) iTargetTop = settings.target; else {
            if ("object" != typeof settings.target || !settings.target.length) return;
            var $target = settings.target;
            iTargetTop = $target.offset().top - iHeaderHeight;
        }
        var iDistance = Math.abs(iWindowScrollTop - iTargetTop), iDistanceMax = settings.distanceMax, iDurationMax = settings.durationMax, iDuration = Math.floor(Math.min(1, iDistance / iDistanceMax) * iDurationMax);
        return $("body, html").animate({
            scrollTop: iTargetTop
        }, iDuration, "easeOutExpo", function() {
            goToDeferred.resolve();
        }), goToDeferred.promise();
    }
};

var initAndAjax = function() {
    $("[data-original]").lazyload(), $(".js-custom-plugin").myCustomPlugin({
        cptStart: 1
    }), $(".skinSelect:not(.js-done)").each(function() {
        $(".skinSelect").select2({
            minimumResultsForSearch: 20
        }).addClass("js-done");
    }), $(".slider-banner:not(.js-done)").addClass("js-done").slick({
        dots: !0,
        fade: !0,
        adaptiveHeight: !0,
        prevArrow: '<button type="button" class="slick-prev"></button>',
        nextArrow: '<button type="button" class="slick-next"></button>'
    }), $(".slider-card-horizontal:not(.js-done)").addClass("js-done").slick({
        dots: !0,
        arrows: !1,
        adaptiveHeight: !0,
        responsive: [ {
            breakpoint: 568,
            settings: "unslick"
        } ]
    }), $(".slider-photo:not(.js-done)").addClass("js-done").slick({
        dots: !0,
        fade: !0,
        adaptiveHeight: !0,
        prevArrow: '<button type="button" class="slick-prev"></button>',
        nextArrow: '<button type="button" class="slick-next"></button>'
    }), $(".tag-with-drop:not(.js-done):not([data-href])").each(function() {
        $(this).addClass("js-done");
        var $dropContent = $(this).siblings(".tag-drop-content").first(), $clone = $dropContent.clone(), sTagColor = void 0 !== $(this).data("tag-color") ? $(this).data("tag-color") : "tag-blue", sPosition = void 0 !== $(this).data("drop-position") ? $(this).data("drop-position") : "bottom left", content = $("<div>").append($dropContent.clone()).html();
        new Drop({
            target: this,
            classes: "drop-theme-arrows " + sTagColor,
            position: sPosition,
            openOn: "click",
            content: content,
            openDelay: 300
        }), $(this).after($clone);
    }), $("body").on("click", ".tag-with-drop[data-href]:not(.js-done)", function() {
        var button = this, $button = $(button);
        $.get($button.data("href"), function(html) {
            $button.addClass("js-done");
            var $dropContent = $(html), $clone = $dropContent.clone(), sTagColor = void 0 !== $button.data("tag-color") ? $button.data("tag-color") : "tag-blue", sPosition = void 0 !== $button.data("drop-position") ? $button.data("drop-position") : "bottom left", content = $("<div>").append($dropContent.clone()).html();
            new Drop({
                target: button,
                classes: "drop-theme-arrows " + sTagColor,
                position: sPosition,
                openOn: "click",
                content: content,
                openDelay: 300
            }), $button.after($clone), $button.click();
        });
    }), $("#citybreak_accommodation_searchform_widget:not(.js-done)").length && loadCitybreakAccomadationForm(), 
    $("#citybreak_event_searchform_widget:not(.js-done)").length && loadCitybreakEventForm(), 
    $(".has-datepicker .datepicker:not(.js-done)").length && $(".has-datepicker .datepicker:not(.js-done)").each(function() {
        $(this).addClass("js-done");
        var oDpOptions = {};
        if ($(this).hasClass("is-birthday") && $.extend(oDpOptions, {
            showOtherMonths: !0,
            selectOtherMonths: !0,
            changeMonth: !0,
            changeYear: !0,
            yearRange: "c-102:c+102",
            minDate: "-120y",
            maxDate: "-18y"
        }), $(this).data("options")) {
            var opt = $(this).data("options");
            $.extend(oDpOptions, opt);
        }
        $(this).datepicker($.extend({}, oDefaultsDatepikerSettings, oDpOptions)), $(this).closest(".reserved-citybreak-form").length && $(this).on("change", function() {
            var sDate = $(this).val();
            $(this).closest(".cb_ev_section_datepicker").length ? $("#cb_ev_form_datefrom").val(sDate) : $("#cb_ev_form_dateto").val(sDate);
        });
    }), initTilesPosition(), $("time.timeago").timeago();
}, isotopeListInit = !1, isotopeList = function() {
    var $isotopeList = $(".js-isotope-list").isotope({
        itemSelector: ".list-item",
        masonry: {
            gutter: 15
        }
    });
    isotopeListInit || ($("body").on("click", ".js-isotope-list .card .js-open-card-tools", function() {
        setTimeout(function() {
            $isotopeList.isotope("layout");
        }, 0);
    }), isotopeListInit = !0);
}, headerAlert = function() {
    var $headerAlert = $(".header-alert"), idHeaderAlert = $headerAlert.attr("id"), headerAlert = docCookies.getItem(idHeaderAlert), expdate = new Date();
    expdate.setTime(expdate.getTime() + 31536e6), $("body").on("click", ".js-close-header-alert", function() {
        $(this).closest(".header-alert").slideUp(), $headerAlert.slideUp(), headerAlert = 3, 
        setTimeout(function() {
            $headerAlert.remove();
        }, 1e3), docCookies.setItem(idHeaderAlert, headerAlert, expdate, "/", null, null);
    }), $headerAlert.length && (null === headerAlert && (headerAlert = 0), headerAlert < 3 ? ($headerAlert.removeClass("is-hidden"), 
    headerAlert++, docCookies.setItem(idHeaderAlert, headerAlert, expdate, "/", null, null)) : $headerAlert.remove());
}, navLang = function() {
    $("body").on("click", ".js-toggle-lang", function() {
        $(".lang-nav").toggleClass("is-opened"), $(".header .lang-list").css({
            top: $(".header").outerHeight()
        }), $(".burger").removeClass("is-opened"), $("body").removeClass("has-mega-menu");
    }), $("body").on("click", ".js-close-lang", function() {
        $(".lang-nav").removeClass("is-opened");
    }), $(document).on("click", function(event) {
        $(event.target).closest(".lang-nav").length || $(".lang-nav").removeClass("is-opened");
    }), $("body").on("click", ".js-toggle-lang-mobile", function() {
        var headerHeight = $(".header").outerHeight();
        $(".mega-menu > .wrapper").css({
            top: headerHeight
        }), $(".lang").toggleClass("is-opened"), $(".mega-menu").toggleClass("has-lang-opened");
    }), $("body").on("click", ".js-close-lang-mobile", function() {
        $(".lang").removeClass("is-opened"), $(".mega-menu").removeClass("has-lang-opened");
    }), $("body").on("click", ".mega-menu .other-lang", function() {
        $(this).toggleClass("is-opened");
    }), $("body").on("click", ".js-close-other-lang-mobile", function(e) {
        e.stopPropagation(), $(".other-lang").removeClass("is-opened");
    }), $("body").on("click", ".direct-access .toggle-direct-access", function() {
        $(".direct-access").toggleClass("is-closed is-opened").closest(".aside-nav").toggleClass("direct-access-is-closed");
    });
}, directAccessMobile = function() {
    $("body").on("click", ".tools-mobile.js-toggle-direct-access", function() {
        var headerHeight = $(".header").outerHeight();
        $("body > .direct-access").css({
            top: headerHeight
        }), $("body").toggleClass("light-off");
    }), $("body").on("click", ".js-close-direct-access", function() {
        $("body").toggleClass("light-off");
    });
}, navMegaMenu = function() {
    $("body").on("click", ".js-toggle-megaMenu", function() {
        $("body > .direct-access").length && ($("body > .direct-access").removeClass("is-opened"), 
        $("body").removeClass("has-direct-access"));
        var headerHeight = $(".header").outerHeight(), windowHeight = $(window).height(), windowTop = $(window).scrollTop();
        windowTop < headerHeight ? ($(".mega-menu").height(windowHeight - (headerHeight - windowTop)), 
        $(".mega-menu").css({
            top: headerHeight - windowTop
        })) : ($(".mega-menu").height(windowHeight), $(".mega-menu").css({
            top: headerHeight
        })), $(".burger").toggleClass("is-opened"), $(".burger-mobile").toggleClass("is-opened"), 
        $(".mega-menu").toggleClass("is-opened"), $("body").toggleClass("has-mega-menu"), 
        $(".mega-menu-tabs-content div.item-link").removeClass("is-opened"), $(".has-links-with-submenu").removeClass("item-link-is-opened");
    }), $(document).on("click", ".mega-menu-tabs [data-tab-target]", function() {
        var sTarget = $(this).attr("data-tab-target").toString(), aTabTargets = [];
        $(this).siblings().each(function() {
            aTabTargets.push($(this).attr("data-tab-target"));
        }), $(this).siblings(".is-opened").removeClass("is-opened"), $(this).addClass("is-opened"), 
        $.each(aTabTargets, function(i, val) {
            $("[data-tab-id=" + val + "].is-opened").removeClass("is-opened is-opened-mobile item-link-is-opened");
        }), $("[data-tab-id=" + sTarget + "]").addClass("is-opened is-opened-mobile"), $(".mega-menu-tabs-content div.item-link").removeClass("is-opened"), 
        $(".mega-menu-footer").addClass("h-hide-xs-max");
    }), $("body").on("click", ".js-close-mega-menu-sub", function() {
        $(".mega-menu [data-tab-id]").removeClass("is-opened is-opened-mobile"), $(".mega-menu-footer").removeClass("h-hide-xs-max");
    }), $("body").on("click", ".mega-menu-tabs-content div.item-link:not(.is-opened)", function(event) {
        event.stopPropagation(), event.preventDefault(), $(this).addClass("is-opened").closest(".has-links-with-submenu").addClass("item-link-is-opened");
    }), $("body").on("click", ".mega-menu-tabs-content .item-link.is-opened .item-title", function(event) {
        event.stopPropagation(), event.preventDefault(), $(this).parent().removeClass("is-opened").closest(".has-links-with-submenu").removeClass("item-link-is-opened");
    });
}, fixedBookingLinks = function() {
    $("body").on("click", ".js-toggle-fixed-links", function() {
        $(this).closest(".panel-links-mobile").toggleClass("is-opened"), $(this).next("div").slideToggle();
    });
}, footerBottomLinks = function() {
    $("body").on("click", ".js-toggle-footerBottomLinks", function() {
        $(this).toggleClass("is-opened"), $(this).next("ul").slideToggle();
    });
}, checkAsideNavColision = function() {
    var $directAccess = $(".direct-access"), $stickySecondaryNav = $(".is-sticky-secondary-nav");
    $directAccess.offset().top + iDirectAccessHeight > $stickySecondaryNav.offset().top - 20 ? $directAccess.addClass("is-closed").closest(".aside-nav").addClass("direct-access-is-closed") : $directAccess.removeClass("is-closed is-opened").closest(".aside-nav").removeClass("direct-access-is-closed");
}, updatePanelNumberpicker = function($numberpicker) {
    var selecteId = $numberpicker.attr("id"), selectedTime = $numberpicker.find("option:selected").val(), $panelNumberpicker = $numberpicker.closest(".panel-numberpicker");
    $panelNumberpicker.find(".number").html(selectedTime), selectedTime > 1 ? $panelNumberpicker.find(".label").addClass("plural").removeClass("single") : $panelNumberpicker.find(".label").removeClass("plural").addClass("single"), 
    "cb_numchild1" == selecteId && (selectedTime > 0 ? $panelNumberpicker.closest("#reserved-citybreak").addClass("has-children-fields") : $panelNumberpicker.closest("#reserved-citybreak").removeClass("has-children-fields"));
};

$(".panel-numberpicker").length && $(".panel-numberpicker select").each(function() {
    updatePanelNumberpicker($(this));
}), $("body").on("change", ".panel-numberpicker select", function() {
    updatePanelNumberpicker($(this));
});

var openPopin = function(content) {
    $("#popin-full-page .popin-page-content").html(content), $("body").addClass("popin-full-page-is-opened");
}, managePopins = function() {
    $("body").on("click", "[data-popin-iframe]", function(event) {
        event.preventDefault(), event.stopPropagation(), openPopin($(this).data("popin-iframe"));
    }), $("body").on("click", ".js-popin-fatmap", function(event) {
        event.preventDefault(), event.stopPropagation();
        var $fatmap = $('<div id="my-fatmap">'), $popinFullPageContent = $("#popin-full-page .popin-page-content");
        $popinFullPageContent.append($fatmap), $popinFullPageContent.addClass("loading").append('<div class="loader"><div></div></div>');
        for (var i = 0; i < 8; i++) $popinFullPageContent.find(".loader > div").append('<span class="bullet"></span>');
        $("body").addClass("popin-full-page-is-opened"), $("#fatmap-load-script").length ? window.initFatmap() : loadFatmap();
    }), $("body").on("click", ".popin-page > .btn-close, .popin-page-under", function(event) {
        event.preventDefault(), event.stopPropagation(), $("body").removeClass("popin-full-page-is-opened popin-page-is-opened"), 
        setTimeout(function() {
            $(".popin-page .popin-page-content").html("");
        }, 1e3);
    }), $("body").on("click", ".js-popin-login-ajax", function(event) {
        window.sessionStorage.hasOwnProperty("loggedin") && window.sessionStorage.loggedin && $("body").off("click", ".js-popin-ajax");
    }), $("body").on("click", ".js-popin-ajax", function(event) {
        event.preventDefault(), event.stopPropagation();
        var $this = $(this), $popinPageContent = $("#popin-page .popin-page-content"), href = $this.data("href") || $this.attr("href");
        $("body").addClass("popin-page-is-opened"), $popinPageContent.html("").addClass("is-loading"), 
        $.ajax({
            type: "GET",
            url: href,
            dataType: "html",
            success: function(data) {
                $popinPageContent.html(data).removeClass("is-loading"), initAndAjax();
            }
        });
    }), $("body").on("submit", "form.js-popin-form", function(event) {
        event.preventDefault();
        var $this = $(this), $popinPageContent = $("#popin-page .popin-page-content");
        $popinPageContent.addClass("is-loading"), $.ajax({
            type: "POST",
            url: $this.attr("action"),
            data: $this.serialize(),
            success: function(data) {
                console.log(data), $popinPageContent.html(data).removeClass("is-loading"), initAndAjax();
            },
            complete: function(jqXHR) {
                console.log(jqXHR);
            }
        });
    });
}, richTextTable = function() {
    $(".rich-text").find("table").not(".js-done").addClass("js-done").each(function() {
        $(this).wrap('<div class="rich-table-wrapper"><div></div></div>');
    });
}, doSearch = function() {
    var $searchForm = $(".form-banner"), $listContainer = $(".isotope-list"), contentTypes = [], openSummer = $(".js-search-filter.summer:not(.off)").length > 0;
    $(".js-search-filter:not(.off):not(.summer)").each(function() {
        contentTypes.push($(this).data("filter"));
    });
    var reqSearch = $(".search-input", $searchForm).val();
    return dataLayer.push({
        event: "declenche-evenement",
        eventCategory: "experience_utilisateur",
        eventAction: "recherche_site",
        eventLabel: reqSearch
    }), $.getJSON($searchForm.data("url"), {
        q: reqSearch,
        page: $listContainer.data("page"),
        contentTypes: contentTypes,
        openSummer: openSummer
    });
}, checkNbResults = function(count) {
    $(".js-filtered-list .card").length === count ? $(".js-bottom-search-list").addClass("is-hidden") : $(".js-bottom-search-list").removeClass("is-hidden");
}, search = function() {
    var $listContainer = $(".isotope-list");
    if ($(".js-filtered-list .card").length === parseInt($(".js-filtered-list").data("count"), 10) && $(".js-bottom-search-list").addClass("is-hidden"), 
    $("body").on("click", ".js-banner-search [data-keyword]", function() {
        var sKeyword = $(this).data("keyword");
        $(this).closest(".banner-search").find(".search-input").val(sKeyword), $(this).closest(".banner-search").find('[type="submit"]').trigger("click");
    }), $("body").on("submit", ".js-banner-search .form-banner", function(e) {
        e.preventDefault(), $listContainer.data("page", 1), $(".js-search-filter:not(.off)").addClass("off"), 
        doSearch().done(function(data) {
            $listContainer.html(data.results), $(".main-title-1").html(data.title + "<span>" + data.subtitle + "</span>"), 
            $(".filter-list").html(data.filters), $listContainer.isotope("destroy"), $listContainer.isotope({
                itemSelector: ".list-item",
                masonry: {
                    gutter: 15
                }
            }), setTimeout(function() {
                checkNbResults(data.count), initAndAjax();
            }, 100), document.goTo({
                target: ".search-input",
                durationMax: 3e3
            });
        });
    }), document.getElementsByName("search-content-more") && $("body").on("click", "#search-content-more", function() {
        $listContainer.data("page", $listContainer.data("page") + 1), doSearch().done(function(data) {
            $listContainer.isotope("insert", $(data.results)), setTimeout(function() {
                checkNbResults(data.count), initAndAjax();
            }, 100);
        });
    }), $("body").on("click", ".js-search-filter", function(event) {
        $(this).toggleClass("off"), $listContainer.data("page", 1), doSearch().done(function(data) {
            $listContainer.html(data.results), $(".main-title-1").html(data.title + "<span>" + data.subtitle + "</span>"), 
            $listContainer.isotope("destroy"), $listContainer.isotope({
                itemSelector: ".list-item",
                masonry: {
                    gutter: 15
                }
            }), setTimeout(function() {
                checkNbResults(data.count), initAndAjax();
            }, 100);
        });
    }), $("body").on("click", ".js-banner-fake-search [data-keyword]", function() {
        var sKeyword = $(this).data("keyword");
        $(this).closest(".banner-search").find(".search-input").val(sKeyword);
    }), $(".js-bottom-search-list").length && $(".btn-go-to-search").length) {
        var sy = $(window).scrollTop(), iWinHeight = $(window).height(), iBottomSearchListOffset = $(".js-bottom-search-list").offset().top, iTopSearchListOffset = $(".js-top-search-list").offset().top;
        $(window).on("scroll", function() {
            sy = $(window).scrollTop(), iBottomSearchListOffset = $(".js-bottom-search-list").offset().top, 
            sy <= iBottomSearchListOffset - iWinHeight && sy >= iTopSearchListOffset ? $(".btn-go-to-search").removeClass("is-opacited") : $(".btn-go-to-search").addClass("is-opacited");
        });
    }
    $("body").on("click", ".btn-go-to-search", function() {
        document.goTo({
            target: 0,
            durationMax: 2e3
        });
    });
}, errorHandler = function() {
    $(".reserved-citybreak-form").removeClass(".is-loading");
    var _text = "<strong>";
    _text += global.citybreak.errorTitle, _text += "</strong>", _text += "<p>", _text += global.citybreak.errorText, 
    _text += "</p>", $(".reserved-citybreak-form").html(_text);
}, oDefaultSlidersSettings = {
    range: {
        min: 0,
        max: 10
    }
};

$(".sliders").length && $(".sliders").each(function() {
    var slider = this, $slider = $(this), $sliderPanel = $slider.closest(".slider-panel"), $sliderInput = $sliderPanel.children("input[type=text],input[type=hidden]"), oSlidersOptions = $.extend({}, oDefaultSlidersSettings);
    $slider.data("options") && $.extend(oSlidersOptions, $slider.data("options"));
    wNumb({
        decimals: 0
    });
    if (void 0 !== oSlidersOptions.tooltip && ($slider.addClass("has-tooltip"), $.extend(oSlidersOptions, {
        tooltips: [ wNumb({
            decimals: 0,
            edit: function(value) {
                return value = Math.round(parseFloat(value)), (value < 10 ? "0" : "") + value;
            }
        }) ]
    })), noUiSlider.create(slider, oSlidersOptions), $sliderInput.length && !$sliderPanel.find(".steps-radio").length && slider.noUiSlider.on("update", function(values, handle) {
        var value = Math.round(parseFloat(values[handle]));
        $sliderInput.val(value).trigger("change");
        var $target = $("." + $sliderInput.attr("id")), $nb = $target.find(".nb");
        0 === value ? $target.addClass("is-hidden") : $target.removeClass("is-hidden"), 
        $nb.html((value < 10 ? "0" : "") + value);
    }), void 0 !== oSlidersOptions.tooltip && $sliderPanel.children(".icon").appendTo($slider.find(".noUi-handle")), 
    $sliderPanel.find(".steps-radio").length) {
        var $stepsRadio = $sliderPanel.find(".step-radio"), setActive = function(i) {
            var step = oSlidersOptions.arraySteps[i], $target = $("." + $sliderInput.attr("id"));
            slider.noUiSlider.set(step[1] * oSlidersOptions.range.max), $stepsRadio.removeClass("is-active").eq(i).addClass("is-active"), 
            $sliderInput.val(step[0]).trigger("change"), $target.length && $target.children().addClass("is-hidden").eq(i).removeClass("is-hidden");
        };
        slider.noUiSlider.on("change", function(values, handle) {
            var arraySteps = oSlidersOptions.arraySteps, iMax = oSlidersOptions.range.max;
            $.each(arraySteps, function(i, step) {
                var min = 0 === i ? 0 : (arraySteps[i][1] / 2 + arraySteps[i - 1][1] / 2) * iMax, max = i === iMax - 2 ? iMax + .1 : (arraySteps[i + 1][1] / 2 + arraySteps[i][1] / 2) * iMax;
                values[handle] >= min && values[handle] < max && setActive(i);
            });
        }), $stepsRadio.each(function() {
            $(this).data({
                slider: slider,
                i: $(this).index()
            }).on("click", function() {
                var i = ($(this).data("slider"), $(this).data("i"));
                setActive(i);
            });
        });
    }
});

var tabbedPanel = function() {
    $(document).on("click", ".tabbed-panel [data-tab-target]", function() {
        var sTarget = $(this).attr("data-tab-target").toString(), aTabTargets = [];
        $(this).siblings().each(function() {
            aTabTargets.push($(this).attr("data-tab-target"));
        }), $(this).siblings(".is-opened").removeClass("is-opened"), $(this).addClass("is-opened"), 
        $.each(aTabTargets, function(i, val) {
            $("[data-tab-id=" + val + "].is-opened").removeClass("is-opened");
        }), $("[data-tab-id=" + sTarget + "]").addClass("is-opened").find(".has-ellipsis").trigger("update");
    });
}, webcams = function() {
    if ($(".panorama-view").length) {
        $(".panorama-view").each(function() {
            $(this).hasClass("no360") ? $(this).panorama360({
                is360: !1
            }) : $(this).panorama360({}), $(this).children(".panorama-nav").on("mouseenter", function() {
                "use strict";
                $(this).siblings(".helper").removeClass("active");
            });
        });
    }
    $("body").on("click", ".toggle-archive", function() {
        $(".webcam-archives").toggleClass("is-opened").find(".content").slideToggle(), $(".webcam-list-menu").removeClass("is-active");
    }), $(document).on("click", function(event) {
        $(event.target).closest(".webcam-archives").length || $(event.target).closest(".ui-datepicker").length || $(event.target).hasClass("ui-icon") || $(".webcam-archives").removeClass("is-opened").find(".content").slideUp();
    }), $("body").on("click", ".js-toggle-webcam-list,.interactiveHtmlMap .icon-marker-filled.is-faded", function() {
        $(".webcam-list-menu").toggleClass("is-active"), $(".webcam-toggle-view .js-toggle-webcam-list, .interactiveHtmlMap .js-toggle-webcam-list, .interactiveHtmlMap .icon-marker-filled").toggleClass("is-faded"), 
        $(".webcam-toggle-view").addClass("h-hide-xs");
    }), $("body").on("submit", ".form-archives", function(event) {
        event.preventDefault();
        var $form = $(this), url = $form.data("url"), $datepicker = $(".datepicker", $form).datepicker("getDate"), dateDay = ("0" + $datepicker.getDate()).slice(-2), dateMonth = ("0" + $datepicker.getMonth()).slice(-2), dateYear = $datepicker.getFullYear(), pushDate = dateDay + "/" + dateMonth + "/" + dateYear;
        console.log(pushDate), dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "webcam_archive",
            eventLabel: pushDate
        }), url = url.replace("__DAY__", dateDay), url = url.replace("__MONTH__", dateMonth), 
        url = url.replace("__YEAR__", dateYear), url = url.replace("__HOUR__", $('select[name="hour"]', $form).val()), 
        url = url.replace("__MINUTE__", $('select[name="minute"]', $form).val()), $.get(url, function(data) {
            data.hasOwnProperty("image_highdef") && $(".panorama-container img").attr("src", data.image_highdef);
        });
    });
};

Modernizr.addTest("csssticky", function() {
    var bool;
    return Modernizr.testStyles("#modernizr { position: -webkit-sticky;position: -moz-sticky;position: -o-sticky; position: -ms-sticky; position: sticky;}", function(elem, rule) {
        bool = -1 !== (window.getComputedStyle ? getComputedStyle(elem, null) : elem.currentStyle).position.indexOf("sticky");
    }), bool;
}), Modernizr.addTest("objectfit", !!Modernizr.prefixed("objectFit")), function($) {
    "use strict";
    $("ol.breadcrumb").appendTo($(".main-content")), $("body").on("click", ".js-test-reset", function() {
        $(this).siblings(".js-custom-plugin").myCustomPlugin("reset");
    }), $("body").on("click", ".js-test-value", function() {
        $(this).siblings(".js-custom-plugin").myCustomPlugin("forceValue", parseInt($(this).data("value"), 10));
    }), $("body").on("click", ".js-test-destroy", function() {
        $(this).siblings(".js-custom-plugin").myCustomPlugin("destroy"), $(this).hide().siblings(".js-test-init").show();
    }), $("body").on("click", ".js-test-init", function() {
        $(this).siblings(".js-custom-plugin").myCustomPlugin(), $(this).hide().siblings(".js-test-destroy").show();
    }), cookiesConsent(), initAndAjax(), both({
        touch: Modernizr.touch,
        name: "both",
        class: !0
    }), headerAlert(), navLang(), navMegaMenu(), directAccessMobile(), counterAnimation(), 
    compassAnimation(), tabbedPanel(), $(".summer-tag.is-opened").length && setTimeout(function() {
        $(".summer-tag.is-opened").removeClass("is-opened");
    }, 3e3), webcams(), $("body").on("submit", "form.js-form-async", function(event) {
        event.preventDefault();
        var $this = $(this);
        $.ajax({
            type: "POST",
            url: $this.attr("action"),
            data: $this.serialize(),
            success: function(data) {
                $($this.data("target-async")).html(data);
            }
        });
    }), $("body").on("click", ".js-goto-sitemap-top", function(e) {
        e.preventDefault(), document.goTo({
            target: "#sitemap-top",
            durationMax: 2e3
        });
    }), $("body").on("click", ".panel-video .js-show-video", function() {
        var $panelVideo = $(this).closest(".panel-video");
        $panelVideo.find(".thumbnail").fadeOut();
        var youtubeID = $panelVideo.data("youtubeid");
        $panelVideo.append('<iframe width="1280" height="720" src="https://www.youtube.com/embed/' + youtubeID + '?rel=0&amp;controls=2&amp;showinfo=0&autoplay=1" frameborder="0" allowfullscreen></iframe>'), 
        $panelVideo.find("iframe").fadeIn();
    }), $("body").on("click", ".panel-video .js-show-playlist", function() {
        var $panelPlaylist = $(this).closest(".panel-video");
        $panelPlaylist.find(".thumbnail").fadeOut();
        var youtubeID = $panelPlaylist.data("youtubeid");
        $panelPlaylist.append('<iframe width="1280" height="720" src="https://www.youtube.com/embed?listType=playlist&amp;list=' + youtubeID + '&rel=0&controls=2&autoplay=1" frameborder="0" allowfullscreen></iframe>'), 
        $panelPlaylist.find("iframe").fadeIn();
    }), $(".lang-list.temp").length && ($(".lang-list.temp li").prependTo($(".lang-list")), 
    $(".lang-list.temp").remove()), $(".js-isotope-list").length && isotopeList(), $(".js-filtered-list").length && filteredList(), 
    $(".js-activities-filtered-list").length && activitiesFilteredList(), $(".js-home-actu-filtered-list").length && homeActuFilteredList(), 
    $("body").on("click", ".panel-ouvertures-piste-rm .title", function() {
        $(this).closest(".panel-ouvertures-piste-rm").toggleClass("is-closed").find(".content").slideToggle();
    }), $("body").on("click", ".js-toggle-panel-share", function() {
        $("body").hasClass("map") ? $(this).siblings(".panel-share-wrapper").find(".panel-share").slideDown().focus() : ($(".panel-share").fadeOut(), 
        $(this).siblings(".panel-share").fadeIn().focus());
    }), $(document).on("click", function(event) {
        $(event.target).closest(".panel-share").length || $(event.target).closest(".js-toggle-panel-share").length || ($("body").hasClass("map") ? $(".panel-share").slideUp() : $(".panel-share").fadeOut());
    }), search(), $("body").on("click", ".js-open-card-tools", function() {
        var _ = $(this);
        _.next().show(), _.hide(), _.prev(".has-ellipsis").removeClass("js-done").trigger("destroy"), 
        setTimeout(function() {
            ellipsisText();
        }, 200);
    }), $("#list-events") && manageEventsList(), footerBottomLinks(), fixedBookingLinks(), 
    bIsPhone ? $(".is-sticky-mobile").stick_in_parent() : ($(".aside-nav").stick_in_parent(), 
    $(".is-sticky").each(function() {
        var stickyOptions = {};
        void 0 !== $(this).data("sticky-options") && $.extend(stickyOptions, $(this).data("sticky-options")), 
        $(this).stick_in_parent(stickyOptions);
    }), $(".is-sticky-secondary-nav").stick_in_parent({
        offset_top: 100
    })), $(".skin-bigfoot").on("click", '.form-group [name*="[posX"], .form-group [name*="[posY"]', function() {
        if (!$(".interactiveHtmlMap").length) {
            var _input = $(this), $mapWrapper = $("<div>");
            $mapWrapper.addClass("interactiveHtmlMapWrapper IMAdminMap").attr({
                id: "map-wrapper",
                "data-current-map": "Admin"
            }), $mapWrapper.append('<div class="interactiveHtmlMap loading"><div id="IMTilesMap" class="IMTilesMap"></div></div><button type="button">X</button>'), 
            $("body").append($mapWrapper), $(".interactiveHtmlMap").manageInteractiveMapTiles(), 
            setTimeout(function() {
                _input.trigger("click");
            }, 500);
        }
    }), $(".interactiveHtmlMap").length && $(".interactiveHtmlMap").manageInteractiveMapTiles(), 
    $window.scroll(function(d, h) {
        iWindowScrollTop = $window.scrollTop(), bIsPhone || (bStickySecondaryNav && checkAsideNavColision(), 
        checkTilesPosition());
    }), $window.trigger("scroll"), managePopins(), $("body").on({
        mouseenter: function() {
            $(this).closest(".card").find(".title").addClass("is-hover");
        },
        mouseleave: function() {
            $(this).closest(".card").find(".title").removeClass("is-hover");
        }
    }, ".card > a[pict]"), $(document).on("click", "[data-popin]", function(e) {
        window.matchMedia("(min-width: 769px)").matches && (e.preventDefault(), e.stopPropagation(), 
        openPopin($(this).attr("data-popin")));
    }), richTextTable(), manageFormFields(), ellipsisText(), responsiveHelper(), accountSetup(), 
    $("body").on("click", ".js-inte-add-map", function(event) {
        var sTypeApp = $(this).data("type-add"), $formField = $(this).closest(".form-field"), sLabel = $(this).siblings("input").val();
        if ("" === sLabel) return !1;
        if ($(this).siblings("input").val(""), "copy-map" == sTypeApp) $formField.siblings(".add-map-confirm").find("strong").html(sLabel), 
        $formField.addClass("is-hidden").siblings("p").toggleClass("is-hidden"); else {
            var $mapList = $formField.siblings(".favorite-map-list"), $checboxFieldTpl = $formField.siblings(".js-checkbox-tpl"), $checboxField = $checboxFieldTpl.clone(), randomId = "map-favorite-" + Math.round(1e3 * Math.random());
            $checboxField.removeClass("is-hidden js-checkbox-tpl").find("label").attr({
                for: randomId
            }).html(sLabel).end().find("input").removeAttr("disabled").attr({
                id: randomId
            }).end().appendTo($mapList).end().find("input").trigger("change");
        }
    }), $("body").on("change", ".js-inte-select-map", function() {
        var $form = $(this).closest("form").addClass("is-loading");
        setTimeout(function() {
            $form.removeClass("is-loading");
        }, 1e3);
    }), $("body").on("click", ".js-inte-remove-map", function() {
        confirm("Attention !\nSi vous effacez cette carte,\ntous les établissements associés ne le seront plus.\n Etes vous sûre ?") && $(this).closest(".form-field").hide().find("input").attr("disabled", "disabled");
    }), $("body").on("click", ".btnKnowMore-sociopro", function(e) {
        var sTitle = $(this).attr("data-title");
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "carte_resort_savoir_plus",
            eventLabel: sTitle
        });
    }), $("body").on("click", ".btnKnowMore-event", function() {
        var sTitle = $(this).attr("data-title");
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "carte_evenement_savoir_plus",
            eventLabel: sTitle
        });
    }), $("body").on("click", ".btnKnowMore-explore", function() {
        var sTitle = $(this).attr("data-title");
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "carte_explore_clic",
            eventLabel: sTitle
        });
    }), $("body").on("click", ".btnKnowMore-explore", function() {
        var sTitle = $(this).attr("data-title");
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "carte_explore_savoir_plus",
            eventLabel: sTitle
        });
    }), $("body").find(".showMap-sociopro").on("click", function() {
        var sTitle = $(this).attr("data-title");
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "carte_resort_clic",
            eventLabel: sTitle
        });
    }), $("body").find(".showMap-event").on("click", function() {
        var sTitle = $(this).attr("data-title");
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "carte_evenement_clic",
            eventLabel: sTitle
        });
    }), $("body").on("click", ".webcam-list-menu a", function() {
        var sTitle = $(this).find("span").text();
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "experience_utilisateur",
            eventAction: "webcam_consultation",
            eventLabel: sTitle
        });
    }), $("#citybreakPage").length > 1 && $("body").on("click", "#cb_ev_SearchButton", function() {
        var dateCB = $("#cb_ev_form_datefrom").val();
        dataLayer.push({
            event: "declenche-evenement",
            eventCategory: "engagement",
            eventAction: "transfert",
            eventLabel: dateCB
        });
    });
}(jQuery);