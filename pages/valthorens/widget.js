

(function () {

    (function (citybreakWidgetLoader) {

        var class2type = {};

        var toString = class2type.toString;

        var hasOwn = class2type.hasOwnProperty;

        var fnToString = hasOwn.toString;

        var ObjectFunctionString = fnToString.call(Object);

        var getProto = Object.getPrototypeOf;

        citybreakWidgetLoader.isWindow = function (obj) {
            return obj != null && obj === obj.window;
        };



        citybreakWidgetLoader.type = function (obj) {
            if (obj == null) {
                return obj + "";
            }

            // Support: Android <=2.3 only (functionish RegExp)
            return typeof obj === "object" || typeof obj === "function" ?
                class2type[toString.call(obj)] || "object" :
                typeof obj;
        };

        citybreakWidgetLoader.isArrayLike = function (obj) {

            // Support: real iOS 8.2 only (not reproducible in simulator)
            // `in` check used to prevent JIT error (gh-2145)
            // hasOwn isn't used here due to false negatives
            // regarding Nodelist length in IE
            var length = !!obj && "length" in obj && obj.length,
                type = citybreakWidgetLoader.type(obj);

            if (type === "function" || citybreakWidgetLoader.isWindow(obj)) {
                return false;
            }

            return type === "array" || length === 0 ||
                typeof length === "number" && length > 0 && (length - 1) in obj;
        };

        citybreakWidgetLoader.each = function (obj, callback) {
            var length, i = 0;

            if (citybreakWidgetLoader.isArrayLike(obj)) {
                length = obj.length;
                for (; i < length; i++) {
                    if (callback.call(obj[i], i, obj[i]) === false) {
                        break;
                    }
                }
            } else {
                for (i in obj) {
                    if (callback.call(obj[i], i, obj[i]) === false) {
                        break;
                    }
                }
            }

            return obj;
        };

        // Populate the class2type map
        citybreakWidgetLoader.each("Boolean Number String Function Array Date RegExp Object Error Symbol".split(" "),
            function (i, name) {
                class2type["[object " + name + "]"] = name.toLowerCase();
            }
        );

        citybreakWidgetLoader.isPlainObject = function (obj) {
            var proto, Ctor;

            // Detect obvious negatives
            // Use toString instead of citybreakWidgetLoader.type to catch host objects
            if (!obj || toString.call(obj) !== "[object Object]") {
                return false;
            }

            proto = getProto(obj);

            // Objects with no prototype (e.g., `Object.create( null )`) are plain
            if (!proto) {
                return true;
            }

            // Objects with prototype are plain iff they were constructed by a global Object function
            Ctor = hasOwn.call(proto, "constructor") && proto.constructor;
            return typeof Ctor === "function" && fnToString.call(Ctor) === ObjectFunctionString;
        };

        citybreakWidgetLoader.isFunction = function (obj) {
            return citybreakWidgetLoader.type(obj) === "function";
        };

        citybreakWidgetLoader.extend = function () {
            var options, name, src, copy, copyIsArray, clone,
                target = arguments[0] || {},
                i = 1,
                length = arguments.length,
                deep = false;

            // Handle a deep copy situation
            if (typeof target === "boolean") {
                deep = target;

                // Skip the boolean and the target
                target = arguments[i] || {};
                i++;
            }

            // Handle case when target is a string or something (possible in deep copy)
            if (typeof target !== "object" && !citybreakWidgetLoader.isFunction(target)) {
                target = {};
            }

            // Extend citybreakjq itself if only one argument is passed
            if (i === length) {
                target = this;
                i--;
            }

            for (; i < length; i++) {

                // Only deal with non-null/undefined values
                if ((options = arguments[i]) != null) {

                    // Extend the base object
                    for (name in options) {
                        src = target[name];
                        copy = options[name];

                        // Prevent never-ending loop
                        if (target === copy) {
                            continue;
                        }

                        // Recurse if we're merging plain objects or arrays
                        if (deep && copy && (citybreakWidgetLoader.isPlainObject(copy) ||
                            (copyIsArray = Array.isArray(copy)))) {

                            if (copyIsArray) {
                                copyIsArray = false;
                                clone = src && Array.isArray(src) ? src : [];

                            } else {
                                clone = src && citybreakWidgetLoader.isPlainObject(src) ? src : {};
                            }

                            // Never move original objects, clone them
                            target[name] = citybreakWidgetLoader.extend(deep, clone, copy);

                            // Don't bring in undefined values
                        } else if (copy !== undefined) {
                            target[name] = copy;
                        }
                    }
                }
            }

            // Return the modified object
            return target;
        };

        citybreakWidgetLoader.headTag = document.getElementsByTagName("head")[0];
        citybreakWidgetLoader.htmlTag = document.documentElement;
        citybreakWidgetLoader.cssInsertTag = (citybreakWidgetLoader.headTag || citybreakWidgetLoader.htmlTag);

        citybreakWidgetLoader.loadCss = function (cssPath) {
            var css_link = document.createElement('link');

            css_link.setAttribute("type", "text/css");
            css_link.setAttribute("rel", "stylesheet");
            css_link.setAttribute("href", cssPath);

            citybreakWidgetLoader.cssInsertTag.appendChild(css_link);
        };

        citybreakWidgetLoader.appendHtml = function (el, str) {
            var div = document.createElement('div');
            div.innerHTML = str;
            while (div.children.length > 0) {
                el.appendChild(div.children[0]);
            }
        }

        var rnothtmlwhite = (/[^\x20\t\r\n\f]+/g);



        // Convert String-formatted options into Object-formatted ones
        function createOptions(options) {
            var object = {};
            citybreakWidgetLoader.each(options.match(rnothtmlwhite) || [], function (_, flag) {
                object[flag] = true;
            });
            return object;
        }

        /*
         * Create a callback list using the following parameters:
         *
         *	options: an optional list of space-separated options that will change how
         *			the callback list behaves or a more traditional option object
         *
         * By default a callback list will act like an event callback list and can be
         * "fired" multiple times.
         *
         * Possible options:
         *
         *	once:			will ensure the callback list can only be fired once (like a Deferred)
         *
         *	memory:			will keep track of previous values and will call any callback added
         *					after the list has been fired right away with the latest "memorized"
         *					values (like a Deferred)
         *
         *	unique:			will ensure a callback can only be added once (no duplicate in the list)
         *
         *	stopOnFalse:	interrupt callings when a callback returns false
         *
         */
        citybreakWidgetLoader.Callbacks = function (options) {

            // Convert options from String-formatted to Object-formatted if needed
            // (we check in cache first)
            options = typeof options === "string" ?
                createOptions(options) :
                citybreakWidgetLoader.extend({}, options);

            var // Flag to know if list is currently firing
                firing,

                // Last fire value for non-forgettable lists
                memory,

                // Flag to know if list was already fired
                fired,

                // Flag to prevent firing
                locked,

                // Actual callback list
                list = [],

                // Queue of execution data for repeatable lists
                queue = [],

                // Index of currently firing callback (modified by add/remove as needed)
                firingIndex = -1,

                // Fire callbacks
                fire = function () {

                    // Enforce single-firing
                    locked = locked || options.once;

                    // Execute callbacks for all pending executions,
                    // respecting firingIndex overrides and runtime changes
                    fired = firing = true;
                    for (; queue.length; firingIndex = -1) {
                        memory = queue.shift();
                        while (++firingIndex < list.length) {

                            // Run callback and check for early termination
                            if (list[firingIndex].apply(memory[0], memory[1]) === false &&
                                options.stopOnFalse) {

                                // Jump to end and forget the data so .add doesn't re-fire
                                firingIndex = list.length;
                                memory = false;
                            }
                        }
                    }

                    // Forget the data if we're done with it
                    if (!options.memory) {
                        memory = false;
                    }

                    firing = false;

                    // Clean up if we're done firing for good
                    if (locked) {

                        // Keep an empty list if we have data for future add calls
                        if (memory) {
                            list = [];

                            // Otherwise, this object is spent
                        } else {
                            list = "";
                        }
                    }
                },

                // Actual Callbacks object
                self = {

                    // Add a callback or a collection of callbacks to the list
                    add: function () {
                        if (list) {

                            // If we have memory from a past run, we should fire after adding
                            if (memory && !firing) {
                                firingIndex = list.length - 1;
                                queue.push(memory);
                            }

                            (function add(args) {
                                citybreakWidgetLoader.each(args, function (_, arg) {
                                    if (citybreakWidgetLoader.isFunction(arg)) {
                                        if (!options.unique || !self.has(arg)) {
                                            list.push(arg);
                                        }
                                    } else if (arg && arg.length && citybreakWidgetLoader.type(arg) !== "string") {

                                        // Inspect recursively
                                        add(arg);
                                    }
                                });
                            })(arguments);

                            if (memory && !firing) {
                                fire();
                            }
                        }
                        return this;
                    },

                    // Remove a callback from the list
                    remove: function () {
                        citybreakWidgetLoader.each(arguments, function (_, arg) {
                            var index;
                            while ((index = citybreakWidgetLoader.inArray(arg, list, index)) > -1) {
                                list.splice(index, 1);

                                // Handle firing indexes
                                if (index <= firingIndex) {
                                    firingIndex--;
                                }
                            }
                        });
                        return this;
                    },

                    // Check if a given callback is in the list.
                    // If no argument is given, return whether or not list has callbacks attached.
                    has: function (fn) {
                        return fn ?
                            citybreakWidgetLoader.inArray(fn, list) > -1 :
                            list.length > 0;
                    },

                    // Remove all callbacks from the list
                    empty: function () {
                        if (list) {
                            list = [];
                        }
                        return this;
                    },

                    // Disable .fire and .add
                    // Abort any current/pending executions
                    // Clear all callbacks and values
                    disable: function () {
                        locked = queue = [];
                        list = memory = "";
                        return this;
                    },
                    disabled: function () {
                        return !list;
                    },

                    // Disable .fire
                    // Also disable .add unless we have memory (since it would have no effect)
                    // Abort any pending executions
                    lock: function () {
                        locked = queue = [];
                        if (!memory && !firing) {
                            list = memory = "";
                        }
                        return this;
                    },
                    locked: function () {
                        return !!locked;
                    },

                    // Call all callbacks with the given context and arguments
                    fireWith: function (context, args) {
                        if (!locked) {
                            args = args || [];
                            args = [context, args.slice ? args.slice() : args];
                            queue.push(args);
                            if (!firing) {
                                fire();
                            }
                        }
                        return this;
                    },

                    // Call all the callbacks with the given arguments
                    fire: function () {
                        self.fireWith(this, arguments);
                        return this;
                    },

                    // To know if the callbacks have already been called at least once
                    fired: function () {
                        return !!fired;
                    }
                };

            return self;
        };

        citybreakWidgetLoader.extend({

            Deferred: function (func) {
                var tuples = [

                        // action, add listener, callbacks,
                        // ... .then handlers, argument index, [final state]
                        ["notify", "progress", citybreakWidgetLoader.Callbacks("memory"),
                            citybreakWidgetLoader.Callbacks("memory"), 2],
                        ["resolve", "done", citybreakWidgetLoader.Callbacks("once memory"),
                            citybreakWidgetLoader.Callbacks("once memory"), 0, "resolved"],
                        ["reject", "fail", citybreakWidgetLoader.Callbacks("once memory"),
                            citybreakWidgetLoader.Callbacks("once memory"), 1, "rejected"]
                ],
                    state = "pending",
                    promise = {
                        state: function () {
                            return state;
                        },
                        always: function () {
                            deferred.done(arguments).fail(arguments);
                            return this;
                        },
                        "catch": function (fn) {
                            return promise.then(null, fn);
                        },

                        // Keep pipe for back-compat
                        pipe: function ( /* fnDone, fnFail, fnProgress */) {
                            var fns = arguments;

                            return citybreakWidgetLoader.Deferred(function (newDefer) {
                                citybreakWidgetLoader.each(tuples, function (i, tuple) {

                                    // Map tuples (progress, done, fail) to arguments (done, fail, progress)
                                    var fn = citybreakWidgetLoader.isFunction(fns[tuple[4]]) && fns[tuple[4]];

                                    // deferred.progress(function() { bind to newDefer or newDefer.notify })
                                    // deferred.done(function() { bind to newDefer or newDefer.resolve })
                                    // deferred.fail(function() { bind to newDefer or newDefer.reject })
                                    deferred[tuple[1]](function () {
                                        var returned = fn && fn.apply(this, arguments);
                                        if (returned && citybreakWidgetLoader.isFunction(returned.promise)) {
                                            returned.promise()
                                                .progress(newDefer.notify)
                                                .done(newDefer.resolve)
                                                .fail(newDefer.reject);
                                        } else {
                                            newDefer[tuple[0] + "With"](
                                                this,
                                                fn ? [returned] : arguments
                                            );
                                        }
                                    });
                                });
                                fns = null;
                            }).promise();
                        },
                        then: function (onFulfilled, onRejected, onProgress) {
                            var maxDepth = 0;
                            function resolve(depth, deferred, handler, special) {
                                return function () {
                                    var that = this,
                                        args = arguments,
                                        mightThrow = function () {
                                            var returned, then;

                                            // Support: Promises/A+ section 2.3.3.3.3
                                            // https://promisesaplus.com/#point-59
                                            // Ignore double-resolution attempts
                                            if (depth < maxDepth) {
                                                return;
                                            }

                                            returned = handler.apply(that, args);

                                            // Support: Promises/A+ section 2.3.1
                                            // https://promisesaplus.com/#point-48
                                            if (returned === deferred.promise()) {
                                                throw new TypeError("Thenable self-resolution");
                                            }

                                            // Support: Promises/A+ sections 2.3.3.1, 3.5
                                            // https://promisesaplus.com/#point-54
                                            // https://promisesaplus.com/#point-75
                                            // Retrieve `then` only once
                                            then = returned &&

                                                // Support: Promises/A+ section 2.3.4
                                                // https://promisesaplus.com/#point-64
                                                // Only check objects and functions for thenability
                                                (typeof returned === "object" ||
                                                    typeof returned === "function") &&
                                                returned.then;

                                            // Handle a returned thenable
                                            if (citybreakWidgetLoader.isFunction(then)) {

                                                // Special processors (notify) just wait for resolution
                                                if (special) {
                                                    then.call(
                                                        returned,
                                                        resolve(maxDepth, deferred, Identity, special),
                                                        resolve(maxDepth, deferred, Thrower, special)
                                                    );

                                                    // Normal processors (resolve) also hook into progress
                                                } else {

                                                    // ...and disregard older resolution values
                                                    maxDepth++;

                                                    then.call(
                                                        returned,
                                                        resolve(maxDepth, deferred, Identity, special),
                                                        resolve(maxDepth, deferred, Thrower, special),
                                                        resolve(maxDepth, deferred, Identity,
                                                            deferred.notifyWith)
                                                    );
                                                }

                                                // Handle all other returned values
                                            } else {

                                                // Only substitute handlers pass on context
                                                // and multiple values (non-spec behavior)
                                                if (handler !== Identity) {
                                                    that = undefined;
                                                    args = [returned];
                                                }

                                                // Process the value(s)
                                                // Default process is resolve
                                                (special || deferred.resolveWith)(that, args);
                                            }
                                        },

                                        // Only normal processors (resolve) catch and reject exceptions
                                        process = special ?
                                        mightThrow :
                                            function () {
                                                try {
                                                    mightThrow();
                                                } catch (e) {

                                                    if (citybreakWidgetLoader.Deferred.exceptionHook) {
                                                        citybreakWidgetLoader.Deferred.exceptionHook(e,
                                                            process.stackTrace);
                                                    }

                                                    // Support: Promises/A+ section 2.3.3.3.4.1
                                                    // https://promisesaplus.com/#point-61
                                                    // Ignore post-resolution exceptions
                                                    if (depth + 1 >= maxDepth) {

                                                        // Only substitute handlers pass on context
                                                        // and multiple values (non-spec behavior)
                                                        if (handler !== Thrower) {
                                                            that = undefined;
                                                            args = [e];
                                                        }

                                                        deferred.rejectWith(that, args);
                                                    }
                                                }
                                            };

                                    // Support: Promises/A+ section 2.3.3.3.1
                                    // https://promisesaplus.com/#point-57
                                    // Re-resolve promises immediately to dodge false rejection from
                                    // subsequent errors
                                    if (depth) {
                                        process();
                                    } else {

                                        // Call an optional hook to record the stack, in case of exception
                                        // since it's otherwise lost when execution goes async
                                        if (citybreakWidgetLoader.Deferred.getStackHook) {
                                            process.stackTrace = citybreakWidgetLoader.Deferred.getStackHook();
                                        }
                                        window.setTimeout(process);
                                    }
                                };
                            }

                            return citybreakWidgetLoader.Deferred(function (newDefer) {

                                // progress_handlers.add( ... )
                                tuples[0][3].add(
                                    resolve(
                                        0,
                                        newDefer,
                                        citybreakWidgetLoader.isFunction(onProgress) ?
                                    onProgress :
                                            Identity,
                                        newDefer.notifyWith
                                    )
                                );

                                // fulfilled_handlers.add( ... )
                                tuples[1][3].add(
                                    resolve(
                                        0,
                                        newDefer,
                                        citybreakWidgetLoader.isFunction(onFulfilled) ?
                                    onFulfilled :
                                            Identity
                                    )
                                );

                                // rejected_handlers.add( ... )
                                tuples[2][3].add(
                                    resolve(
                                        0,
                                        newDefer,
                                        citybreakWidgetLoader.isFunction(onRejected) ?
                                    onRejected :
                                            Thrower
                                    )
                                );
                            }).promise();
                        },

                        // Get a promise for this deferred
                        // If obj is provided, the promise aspect is added to the object
                        promise: function (obj) {
                            return obj != null ? citybreakWidgetLoader.extend(obj, promise) : promise;
                        }
                    },
                    deferred = {};

                // Add list-specific methods
                citybreakWidgetLoader.each(tuples, function (i, tuple) {
                    var list = tuple[2],
                        stateString = tuple[5];

                    // promise.progress = list.add
                    // promise.done = list.add
                    // promise.fail = list.add
                    promise[tuple[1]] = list.add;

                    // Handle state
                    if (stateString) {
                        list.add(
                            function () {

                                // state = "resolved" (i.e., fulfilled)
                                // state = "rejected"
                                state = stateString;
                            },

                            // rejected_callbacks.disable
                            // fulfilled_callbacks.disable
                            tuples[3 - i][2].disable,

                            // progress_callbacks.lock
                            tuples[0][2].lock
                        );
                    }

                    // progress_handlers.fire
                    // fulfilled_handlers.fire
                    // rejected_handlers.fire
                    list.add(tuple[3].fire);

                    // deferred.notify = function() { deferred.notifyWith(...) }
                    // deferred.resolve = function() { deferred.resolveWith(...) }
                    // deferred.reject = function() { deferred.rejectWith(...) }
                    deferred[tuple[0]] = function () {
                        deferred[tuple[0] + "With"](this === deferred ? undefined : this, arguments);
                        return this;
                    };

                    // deferred.notifyWith = list.fireWith
                    // deferred.resolveWith = list.fireWith
                    // deferred.rejectWith = list.fireWith
                    deferred[tuple[0] + "With"] = list.fireWith;
                });

                // Make the deferred a promise
                promise.promise(deferred);

                // Call given func if any
                if (func) {
                    func.call(deferred, deferred);
                }

                // All done!
                return deferred;
            },

            // Deferred helper
            when: function (singleValue) {
                var

                    // count of uncompleted subordinates
                    remaining = arguments.length,

                    // count of unprocessed arguments
                    i = remaining,

                    // subordinate fulfillment data
                    resolveContexts = Array(i),
                    resolveValues = slice.call(arguments),

                    // the master Deferred
                    master = citybreakWidgetLoader.Deferred(),

                    // subordinate callback factory
                    updateFunc = function (i) {
                        return function (value) {
                            resolveContexts[i] = this;
                            resolveValues[i] = arguments.length > 1 ? slice.call(arguments) : value;
                            if (!(--remaining)) {
                                master.resolveWith(resolveContexts, resolveValues);
                            }
                        };
                    };

                // Single- and empty arguments are adopted like Promise.resolve
                if (remaining <= 1) {
                    adoptValue(singleValue, master.done(updateFunc(i)).resolve, master.reject,
                        !remaining);

                    // Use .then() to unwrap secondary thenables (cf. gh-3000)
                    if (master.state() === "pending" ||
                        citybreakWidgetLoader.isFunction(resolveValues[i] && resolveValues[i].then)) {

                        return master.then();
                    }
                }

                // Multiple arguments are aggregated like Promise.all array elements
                while (i--) {
                    adoptValue(resolveValues[i], updateFunc(i), master.reject);
                }

                return master.promise();
            }
        });

        // These usually indicate a programmer mistake during development,
        // warn about them ASAP rather than swallowing them by default.
        var rerrorNames = /^(Eval|Internal|Range|Reference|Syntax|Type|URI)Error$/;

        citybreakWidgetLoader.Deferred.exceptionHook = function (error, stack) {

            // Support: IE 8 - 9 only
            // Console exists when dev tools are open, which can happen at any time
            if (window.console && window.console.warn && error && rerrorNames.test(error.name)) {
                window.console.warn("citybreakWidgetLoader.Deferred exception: " + error.message, error.stack, stack);
            }
        };




        citybreakWidgetLoader.readyException = function (error) {
            window.setTimeout(function () {
                throw error;
            });
        };




        // The deferred used on DOM ready
        var readyList = citybreakWidgetLoader.Deferred();

        citybreakWidgetLoader.ready = function (fn) {

            readyList
                .then(fn)

                // Wrap citybreakWidgetLoader.readyException in a function so that the lookup
                // happens at the time of error handling instead of callback
                // registration.
                .catch(function (error) {
                    citybreakWidgetLoader.readyException(error);
                });

            return this;
        };

        citybreakWidgetLoader.extend({

            // Is the DOM ready to be used? Set to true once it occurs.
            isReady: false,

            // A counter to track how many items to wait for before
            // the ready event fires. See #6781
            readyWait: 1,

            // Handle when the DOM is ready
            ready: function (wait) {

                // Abort if there are pending holds or we're already ready
                if (wait === true ? --citybreakWidgetLoader.readyWait : citybreakWidgetLoader.isReady) {
                    return;
                }

                // Remember that the DOM is ready
                citybreakWidgetLoader.isReady = true;

                // If a normal DOM Ready event fired, decrement, and wait if need be
                if (wait !== true && --citybreakWidgetLoader.readyWait > 0) {
                    return;
                }

                // If there are functions bound, to execute
                readyList.resolveWith(document, [citybreakWidgetLoader]);
            }
        });

        citybreakWidgetLoader.ready.then = readyList.then;

        // The ready event handler and self cleanup method
        function completed() {
            document.removeEventListener("DOMContentLoaded", completed);
            window.removeEventListener("load", completed);
            citybreakWidgetLoader.ready();
        }

        // Catch cases where $(document).ready() is called
        // after the browser event has already occurred.
        // Support: IE <=9 - 10 only
        // Older IE sometimes signals "interactive" too soon
        if (document.readyState === "complete" ||
            (document.readyState !== "loading" && !document.documentElement.doScroll)) {

            // Handle it asynchronously to allow scripts the opportunity to delay ready
            window.setTimeout(citybreakWidgetLoader.ready);

        } else {

            // Use the handy event callback
            document.addEventListener("DOMContentLoaded", completed);

            // A fallback to window.onload, that will always work
            window.addEventListener("load", completed);
        }

    })(window.citybreakWidgetLoader = window.citybreakWidgetLoader || {});


    /*! LAB.js (LABjs :: Loading And Blocking JavaScript)
        v2.0.3 (c) Kyle Simpson
        MIT License
    */
    (function (o) { var K = o.$LAB, y = "UseLocalXHR", z = "AlwaysPreserveOrder", u = "AllowDuplicates", A = "CacheBust", B = "BasePath", C = /^[^?#]*\//.exec(location.href)[0], D = /^\w+\:\/\/\/?[^\/]+/.exec(C)[0], i = document.head || document.getElementsByTagName("head"), L = (o.opera && Object.prototype.toString.call(o.opera) == "[object Opera]") || ("MozAppearance" in document.documentElement.style), q = document.createElement("script"), E = typeof q.preload == "boolean", r = E || (q.readyState && q.readyState == "uninitialized"), F = !r && q.async === true, M = !r && !F && !L; function G(a) { return Object.prototype.toString.call(a) == "[object Function]" } function H(a) { return Object.prototype.toString.call(a) == "[object Array]" } function N(a, c) { var b = /^\w+\:\/\//; if (/^\/\/\/?/.test(a)) { a = location.protocol + a } else if (!b.test(a) && a.charAt(0) != "/") { a = (c || "") + a } return b.test(a) ? a : ((a.charAt(0) == "/" ? D : C) + a) } function s(a, c) { for (var b in a) { if (a.hasOwnProperty(b)) { c[b] = a[b] } } return c } function O(a) { var c = false; for (var b = 0; b < a.scripts.length; b++) { if (a.scripts[b].ready && a.scripts[b].exec_trigger) { c = true; a.scripts[b].exec_trigger(); a.scripts[b].exec_trigger = null } } return c } function t(a, c, b, d) { a.onload = a.onreadystatechange = function () { if ((a.readyState && a.readyState != "complete" && a.readyState != "loaded") || c[b]) return; a.onload = a.onreadystatechange = null; d() } } function I(a) { a.ready = a.finished = true; for (var c = 0; c < a.finished_listeners.length; c++) { a.finished_listeners[c]() } a.ready_listeners = []; a.finished_listeners = [] } function P(d, f, e, g, h) { setTimeout(function () { var a, c = f.real_src, b; if ("item" in i) { if (!i[0]) { setTimeout(arguments.callee, 25); return } i = i[0] } a = document.createElement("script"); if (f.type) a.type = f.type; if (f.charset) a.charset = f.charset; if (h) { if (r) { e.elem = a; if (E) { a.preload = true; a.onpreload = g } else { a.onreadystatechange = function () { if (a.readyState == "loaded") g() } } a.src = c } else if (h && c.indexOf(D) == 0 && d[y]) { b = new XMLHttpRequest(); b.onreadystatechange = function () { if (b.readyState == 4) { b.onreadystatechange = function () { }; e.text = b.responseText + "\n//@ sourceURL=" + c; g() } }; b.open("GET", c); b.send() } else { a.type = "text/cache-script"; t(a, e, "ready", function () { i.removeChild(a); g() }); a.src = c; i.insertBefore(a, i.firstChild) } } else if (F) { a.async = false; t(a, e, "finished", g); a.src = c; i.insertBefore(a, i.firstChild) } else { t(a, e, "finished", g); a.src = c; i.insertBefore(a, i.firstChild) } }, 0) } function J() { var l = {}, Q = r || M, n = [], p = {}, m; l[y] = true; l[z] = false; l[u] = false; l[A] = false; l[B] = ""; function R(a, c, b) { var d; function f() { if (d != null) { d = null; I(b) } } if (p[c.src].finished) return; if (!a[u]) p[c.src].finished = true; d = b.elem || document.createElement("script"); if (c.type) d.type = c.type; if (c.charset) d.charset = c.charset; t(d, b, "finished", f); if (b.elem) { b.elem = null } else if (b.text) { d.onload = d.onreadystatechange = null; d.text = b.text } else { d.src = c.real_src } i.insertBefore(d, i.firstChild); if (b.text) { f() } } function S(c, b, d, f) { var e, g, h = function () { b.ready_cb(b, function () { R(c, b, e) }) }, j = function () { b.finished_cb(b, d) }; b.src = N(b.src, c[B]); b.real_src = b.src + (c[A] ? ((/\?.*$/.test(b.src) ? "&_" : "?_") + ~~(Math.random() * 1E9) + "=") : ""); if (!p[b.src]) p[b.src] = { items: [], finished: false }; g = p[b.src].items; if (c[u] || g.length == 0) { e = g[g.length] = { ready: false, finished: false, ready_listeners: [h], finished_listeners: [j] }; P(c, b, e, ((f) ? function () { e.ready = true; for (var a = 0; a < e.ready_listeners.length; a++) { e.ready_listeners[a]() } e.ready_listeners = [] } : function () { I(e) }), f) } else { e = g[0]; if (e.finished) { j() } else { e.finished_listeners.push(j) } } } function v() { var e, g = s(l, {}), h = [], j = 0, w = false, k; function T(a, c) { a.ready = true; a.exec_trigger = c; x() } function U(a, c) { a.ready = a.finished = true; a.exec_trigger = null; for (var b = 0; b < c.scripts.length; b++) { if (!c.scripts[b].finished) return } c.finished = true; x() } function x() { while (j < h.length) { if (G(h[j])) { try { h[j++]() } catch (err) { } continue } else if (!h[j].finished) { if (O(h[j])) continue; break } j++ } if (j == h.length) { w = false; k = false } } function V() { if (!k || !k.scripts) { h.push(k = { scripts: [], finished: true }) } } e = { script: function () { for (var f = 0; f < arguments.length; f++) { (function (a, c) { var b; if (!H(a)) { c = [a] } for (var d = 0; d < c.length; d++) { V(); a = c[d]; if (G(a)) a = a(); if (!a) continue; if (H(a)) { b = [].slice.call(a); b.unshift(d, 1);[].splice.apply(c, b); d--; continue } if (typeof a == "string") a = { src: a }; a = s(a, { ready: false, ready_cb: T, finished: false, finished_cb: U }); k.finished = false; k.scripts.push(a); S(g, a, k, (Q && w)); w = true; if (g[z]) e.wait() } })(arguments[f], arguments[f]) } return e }, wait: function () { if (arguments.length > 0) { for (var a = 0; a < arguments.length; a++) { h.push(arguments[a]) } k = h[h.length - 1] } else k = false; x(); return e } }; return { script: e.script, wait: e.wait, setOptions: function (a) { s(a, g); return e } } } m = { setGlobalDefaults: function (a) { s(a, l); return m }, setOptions: function () { return v().setOptions.apply(null, arguments) }, script: function () { return v().script.apply(null, arguments) }, wait: function () { return v().wait.apply(null, arguments) }, queueScript: function () { n[n.length] = { type: "script", args: [].slice.call(arguments) }; return m }, queueWait: function () { n[n.length] = { type: "wait", args: [].slice.call(arguments) }; return m }, runQueue: function () { var a = m, c = n.length, b = c, d; for (; --b >= 0;) { d = n.shift(); a = a[d.type].apply(null, d.args) } return a }, noConflict: function () { o.$LAB = K; return m }, sandbox: function () { return J() } }; return m } o.$LAB = J(); (function (a, c, b) { if (document.readyState == null && document[a]) { document.readyState = "loading"; document[a](c, b = function () { document.removeEventListener(c, b, false); document.readyState = "complete" }, false) } })("addEventListener", "DOMContentLoaded") })(window.citybreakWidgetLoader);

    /* https://github.com/furf/jquery-onavailable/blob/master/jquery.onAvailable-1.0.min.js */

    (function (A) { A.extend({ onAvailable: function (C, F) { if (typeof F !== "function") { throw new TypeError(); } var E = A.onAvailable; if (!(C instanceof Array)) { C = [C]; } for (var B = 0, D = C.length; B < D; ++B) { E.listeners.push({ id: C[B], callback: F, obj: arguments[2], override: arguments[3], checkContent: !!arguments[4] }); } if (!E.interval) { E.interval = window.setInterval(E.checkAvailable, E.POLL_INTERVAL); } return this; }, onContentReady: function (C, E, D, B) { A.onAvailable(C, E, D, B, true); } }); A.extend(A.onAvailable, { POLL_RETRIES: 2000, POLL_INTERVAL: 20, interval: null, listeners: [], executeCallback: function (C, D) { var B = C; if (D.override) { if (D.override === true) { B = D.obj; } else { B = D.override; } } D.callback.call(B, D.obj); }, checkAvailable: function () { var F = A.onAvailable; var D = F.listeners; for (var B = 0; B < D.length; ++B) { var E = D[B]; var C = document.getElementById(E.id); if (C && (!E.checkContent || (E.checkContent && (C.nextSibling || C.parentNode.nextSibling || A.isReady)))) { F.executeCallback(C, E); D.splice(B, 1); --B; } if (D.length === 0 || --F.POLL_RETRIES === 0) { F.interval = window.clearInterval(F.interval); } } } }); })(window.citybreakWidgetLoader);
    var POLL_RETRIES = 6000 * 10;
    var POLL_INTERVAL = 20;

    var pollRetries, interval, onContentReadyExecuted;

    window.citybreakWidgetLoader.onAvailable.POLL_RETRIES = POLL_RETRIES;

    window.citybreakWidgetLoader.doneLoadingResources = [];

    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_accommodationflight_searchform_widget', function () {
            console.log('onContentReady #citybreak_accommodationflight_searchform_widget, executing');

            var target = document.getElementById('citybreak_accommodationflight_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_accommodationflight_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_accommodationflight_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_accommodationflight_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine cb-widget-search\" id=\"cb_accommodationflight_searchform_form\">\r\n\r\n    <!-- destination -->\r\n    <div class=\"cb-block cb-block-destination\">\r\n\r\n        <div class=\"cb-item\">\r\n            <span class=\"cb-label-title\"><b>搜索目的地:</b></span>\r\n            <label class=\"cb-form-icon cb-icon-flight\">\r\n                    <select id=\"destinationLocation\" name=\"destinationLocation\" class=\"cb-form-select\" title=\"搜索目的地\">\r\n                        <option value=\"\">选择目的地</option>\r\n                    </select>\r\n            </label>\r\n        </div>\r\n        <div class=\"cb-item\">\r\n            <span class=\"cb-label-title\"><b>出发城市:</b></span>\r\n            <label class=\"cb-form-icon cb-icon-flight\">\r\n                    <select id=\"departureLocation\" name=\"departureLocation\" class=\"cb-form-select\" title=\"出发城市\">\r\n                        <option value=\"\">选择出发城市</option>\r\n                    </select>\r\n            </label>\r\n        </div>\r\n\r\n    </div>\r\n    <!-- // destination -->\r\n\r\n\r\n\t<!-- dates & guests -->\r\n\t<div class=\"cb-block cb-block-dates-guests\">\r\n\t\t<div class=\"cb-item cb-item-date-from\">\r\n\t\t\t<span class=\"cb-label-title\"><b>出发日期:</b></span>\r\n\t\t\t<label class=\"cb-form-icon cb-icon-date\">\r\n\t\t\t\t<input title=\"出发日期\" name=\"startdate\" type=\"text\" class=\"cb-form-text\" id=\"cb_accommodationflight_datefrom\" />\r\n\t\t\t\t<span></span>\r\n\t\t\t</label>\r\n\t\t</div>\r\n\t\t<div class=\"cb-item cb-item-date-to\">\r\n\t\t\t<span class=\"cb-label-title\"><b>返回日期:</b></span>\r\n\t\t\t<label class=\"cb-form-icon cb-icon-date\">\r\n\t\t\t\t<input title=\"返回日期\" name=\"enddate\" type=\"text\" class=\"cb-form-text\" id=\"cb_accommodationflight_dateto\" />\r\n\t\t\t\t<span></span>\r\n\t\t\t</label>\r\n\t\t</div>\r\n\t\t<div id=\"cb-accommodationflight-roomselector\" class=\"cb-item cb-item-guests\">\r\n\t\t\t<span class=\"cb-label-title\"><b>号。房间和人:</b></span>\r\n\t\t\t<span class=\"cb-form-icon cb-icon-caret\">\r\n    <label class=\"cb-form-text cb-js-roomsguest-text\"></label>\r\n\t<span></span>\r\n</span>\r\n\t\t</div>\r\n\t</div>\r\n\t<!-- // dates & guests -->\r\n\r\n\r\n\t<!-- action -->\r\n\t<div class=\"cb-actions\">\r\n\t\t<a href=\"#\" class=\"cb-button\" id=\"cb_accommodationflight_searchbutton\">\r\n\t\t\t<span class=\"cb-btn-inner\">搜寻航班+住宿</span>\r\n\t\t\t<span class=\"cb-btn-bg\"></span>\r\n\t\t</a>\r\n\t</div>\r\n\t<!-- // action -->\r\n\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_accommodationflight_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_accommodationflight_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {


                    var searchformMessages = {
                        invalidDeparture: "选择出发",
                        invalidDestination: "选择一个目的地",
                        invalidStartDate: "Invalid start date",
                        invalidEndDate: "Invalid end date",
                        CookieAlert: 'Warning! Cookies are disabled. '
                    };

                    var accommodationFlightRoomConfigOptions = {
                        minChildAge: 0,
                        maxChildAge: 17,
                        maxNoRooms: 5,
                        maxNoAdults: 9,
                        maxNoChildren: 5,
                        maxNoTotalPersons: 30,
                        validationMessages: {
                            invalidNumberOfRooms: "Invalid number of rooms",
                            invalidNumberOfAdults: "Invalid number of adults",
                            invalidNumberOfChildren: "Invalid number of children",
                            invalidChildAge: "Specify age of children",
                            invalidNumberOfTotalPersons: "You can only search for max {0} persons at a time."
                        },
                        translations: {
                            room: "房间",
                            rooms: "客房",
                            person: "人",
                            persons: "人",
                            adult: "成人",
                            adults: "成人",
                            child: "孩子",
                            children: "孩子",
                            removeRoom: "清除",
                            addRoom: "添加房间",
                            done: "做",
                            cancel: "取消",
                            agesOfChildren: '儿童的年龄（0  -  17岁）'
                        },
                        placementRequests: [{ "IsEmpty": false, "IsValid": true, "Adults": 2, "Children": [] }]
                    };

                    var searchformOptions = {
                        url: 'http://online3-next.citybreak.com/537027515/zh/accommodationflightpackagesearch/search',
                        messages: searchformMessages,
                        startDate: new Date(2019, 5, 18, 0, 0, 0, 0),
                        endDate: new Date(2019, 5, 19, 0, 0, 0, 0),
                        minDate: new Date(2019, 5, 18, 0, 0, 0, 0),
                        defaultStayDaysLength: 1,
                        roomConfigOptions: accommodationFlightRoomConfigOptions
                    };

                    window.citybreakAccommodationFlightSearchform.initialize(searchformOptions);



                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_accommodationflight_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_accommodationflight_searchform_widget, executing');

            var target = citybreakjq('#citybreak_accommodationflight_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_accommodationflight_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_accommodationflight_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_accommodationflight_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_accommodationflight_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_accommodation_popular_widget', function () {
            console.log('onContentReady #citybreak_accommodation_popular_widget, executing');

            var target = document.getElementById('citybreak_accommodation_popular_widget');

            if (!target) {
                console.log('onContentReady #citybreak_accommodation_popular_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_accommodation_popular_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_accommodation_popular_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_PopularAccommodations\">\r\n\t<div class=\"cb_inner\">\r\n\t\t<div class=\"cb_ex\"></div>\r\n\t\t<div class=\"cb_hd\">\r\n\t\t\t<h2>我们的客人&amp;#39;我的最爱</h2>\r\n\t\t</div>\r\n\t\t<div class=\"cb_bd\">\r\n\t\t\t<div class=\"cb_copy cb_clr\">\r\n\r\n\t\t\t</div>\r\n\t\t</div>\r\n\t\t<div class=\"cb_ft\"></div>\r\n\t</div>\r\n</div>");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_accommodation_popular_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_accommodation_popular_widget, executing inline widget scripts');





                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_accommodation_popular_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_accommodation_popular_widget, executing');

            var target = citybreakjq('#citybreak_accommodation_popular_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_accommodation_popular_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_accommodation_popular_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_accommodation_popular_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_accommodation_popular_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_accommodation_searchform_widget', function () {
            console.log('onContentReady #citybreak_accommodation_searchform_widget, executing');

            var target = document.getElementById('citybreak_accommodation_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_accommodation_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_accommodation_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_accommodation_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "\r\n\r\n<div class=\"Citybreak_engine\">\r\n\t<div class=\"Citybreak_SidebarBox Citybreak_Search cb_accommodation_searchbox\">\r\n\t\t<div class=\"cb_inner\">\r\n\t\t\t<div class=\"cb_ex\"></div>\r\n\t\t\t<div class=\"cb_hd\">\r\n\t\t\t\t<h4>搜寻酒店</h4>\r\n\t\t\t\t<span class=\"cb_ex_label\" title=\"住宿\">住宿</span>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_bd\">\r\n\t\t\t\r\n\r\n\r\n<div id=\"Citybreak_bookingdetails\" class=\"cb_hidden\">\r\n\t<div class=\"cb_search_summary\">\r\n\t\t<div class=\"cb_copy\">\r\n\t\t\t<ul>\r\n\t\t\t\t\r\n\t\t\t\t\r\n\r\n\t\t\t\t    <li class=\"cb_acc_type\">\r\n\t\t\t\t\t    <span class=\"cb_lbl\">住宿类型:</span>\r\n\t\t\t\t\t    所有\r\n\t\t\t\t    </li>\r\n\r\n\r\n\r\n\r\n\t\t\t\t<li>\r\n\t\t\t\t\t<span class=\"cb_lbl\">\r\n                            入住:\r\n\t\t\t\t\t</span>\r\n\t\t\t\t\t周三 19 6月 2019\r\n\t\t\t\t</li>\r\n\r\n\t\t\t\t    <li>\r\n\t\t\t\t\t    <span class=\"cb_lbl\">退房:</span>\r\n\t\t\t\t\t    周三 26 6月 2019\r\n\t\t\t\t    </li>\r\n\t\t\t\t    <li>\r\n\t\t\t\t\t    <span class=\"cb_lbl\">夜:</span>\r\n\t\t\t\t\t    7\r\n\t\t\t\t    </li>\r\n\r\n\r\n\r\n\t\t\t\t    <li>\r\n\t\t\t\t\t    <span class=\"cb_lbl\">客房:</span>\r\n\t\t\t\t\t    1\r\n\t\t\t\t    </li>\r\n\r\n\t\t\t\t<li>\r\n\t\t\t\t\t<span class=\"cb_lbl\">宾客:</span>\r\n\t\t\t\t\t2\r\n\r\n\t\t\t\t\t成人\r\n\t\t\t\t    \r\n\t\t\t\t</li>\r\n\t\t\t\t\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t</ul>\r\n\t\t</div>\r\n\t</div>\r\n\t<div class=\"cb_btn cb_clr\">\r\n\t\t<a href=\"javascript:;\" class=\"Citybreak_change_link\" id=\"Citybreak_changebooking\" title=\"更改搜索\">\r\n\t\t\t<span class=\"cb_icon cb_expandicon\"></span><span>更改搜索</span>\r\n\t\t</a>\r\n\t</div>\r\n</div>\r\n\t\t\t\r\n<form action=\"http://online3-next.citybreak.com/537027515/zh/accommodationsearch/search\" method=\"post\" id=\"form0\" accept-charset=\"UTF-8\" name=\"basketFormDelete\">\t\t\t\t\t<input type=\"hidden\" id=\"cb_searchstring\" value=\"2\" name=\"pr\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_discountCategoryId\" value=\"\" name=\"discountCategoryId\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_packageLightCategoryId\" value=\"\" name=\"packageLightCategoryId\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_discountId\" value=\"\" name=\"discountId\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_poiId\" value=\"\" name=\"cb_poiId\" />\r\n                    <input type=\"hidden\" id=\"cb_geoId\" value=\"\" name=\"cb_geoId\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_locationAttribute\" value=\"\" name=\"cb_locationAttribute\"/>\t\t\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_city\" value=\"\" name=\"cb_city\" />\r\n\t\t\t\t\t<input type=\"hidden\" value=\"false\" name=\"islockedbycategory\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_distanceLimit\" value=\"\" name=\"cb_distanceLimit\" />\r\n\t\t\t\t\t<input type=\"hidden\" name=\"cb_nojs\" value=\"1\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_productIds\" value=\"\" name=\"cb_productIds\" />\r\n\t\t\t\t\t<div id=\"Citybreak_bookingform\">\r\n\t\t\t\t\t\t<div class=\"cb_copy cb_clr\">\r\n\t\t\t\t\t\t\t<div class=\"Citybreak_SearchBox cb_clr\">\r\n\r\n\t\t\t\t\t\t\t                                    \r\n                                \r\n<div id=\"cb_acc_wheredoyouwanttostay_cnt\" class=\"\">\r\n\r\n\r\n\t<div class=\"cb_form_row cb_ac_section_keyword \">\t    \r\n\r\n        <label class=\"cb_titlelabel\">搜寻地区，地标或酒店名称:</label>\r\n\r\n\t\t<div class=\"cb_keyword_input\"><label><input title=\"搜寻地区，地标或酒店名称\" value=\"\" type=\"text\" id=\"cb_ac_searchfield\"  name=\"wheredoyouwanttostay\" /></label></div>\r\n\t</div>\r\n\r\n\t<div id=\"cbnoresult_srch\" class=\"cb_noresults_msg\"></div>\r\n</div>\r\n\r\n\r\n\r\n\t\t\t\t\t\t\t    \r\n<style>\r\n    .hide_acc_type {\r\n        display: none !important;\r\n    }\r\n</style>\r\n\r\n\r\n\t    <div class=\"cb_form_row cb_ac_section_accomodationtype \" id=\"cb_acc_accommodationtype_cnt\">\r\n\t        <label class=\"cb_titlelabel\">住宿类型:</label> \r\n\t        <div class=\"cb_selects cb_selects_wide\">\r\n                <select id=\"cb_accommodationtype\" class=\"cb-js-accommodationtype\" name=\"cb_categoryId\"  title=\"住宿类型\">\r\n                        <option  value=\"32542\">Deluxe Chalets</option>\r\n                        <option  value=\"16616\">Hotel</option>\r\n                        <option  value=\"16617\">Residence</option>\r\n                        <option  value=\"16620\">Self-catered apartment</option>\r\n                        <option  value=\"27621\">UCPA youth hostel </option>\r\n                        <option selected value=\"16615\">所有</option>\r\n                </select>\r\n\t        </div>\r\n\t    </div>\r\n\r\n                               \r\n\r\n\t\t\t\t\t\t\t    <div class=\"cb_clr\"><span></span></div>\r\n\t\t\t\t\t\t\t\t\r\n\r\n<div id=\"cb_acc_typeofdatesearch_cnt\" style=\"display: none;\">\r\n    \r\n\t<div class=\"cb_form_row cb_ac_section_dates\">\r\n\t\t<label class=\"cb_main_formlabel\">最新搜索类型:</label>\r\n\t\t<div class=\"cb_radio\">\r\n\t\t\t<label>\r\n\t\t\t\t<input title=\"最新搜索类型\" name=\"cb_acc_typeofdatesearch\" type=\"radio\" value=\"date\" id=\"cb_acc_typeofdatesearch_date\" checked=\"checked\"/>\r\n\t\t\t\t<span class=\"cb_radio_lbl\">日期搜索</span>\r\n\t\t\t</label>\t\t\t\r\n\t\t</div>\r\n        \r\n\t\t<div class=\"cb_radio\">\t\t\t\r\n\t\t\t<label>\r\n\t\t\t\t<input title=\"一周搜索\" name=\"cb_acc_typeofdatesearch\" type=\"radio\" value=\"week\" id=\"cb_acc_typeofdatesearch_week\" />\r\n\t\t\t\t<span class=\"cb_radio_lbl\">一周搜索</span>\r\n\t\t\t</label>\t\t\t\r\n\t\t</div>\r\n\t</div>\r\n\r\n    <div class=\"cb_form_weekpicker_cnt\">\r\n        \r\n\t</div>\r\n</div>\r\n\r\n<div id=\"cb_acc_datepicker_cnt\" >\r\n    <div>\r\n\t\t    <div class=\"cb_form_row cb_2col cb_ac_section_dates\">\r\n\t\t        <div class=\"cb_col_left\">\r\n\t\t\t        <label class=\"cb_titlelabel\">入住:</label>\r\n\t\t            <div class=\"cb_date_input\">\r\n\t\t                <label>\r\n\t\t                    <span class=\"cb_acc_datefrom_label\" style=\"display: none\">\r\n                                <span class=\"cb_acc_datefrom_day\"></span>\r\n                                <span class=\"cb_acc_datefrom_month\"></span>\r\n                                <span class=\"cb_acc_datefrom_year\"></span>\r\n                            </span>    \r\n\t\t                    <input title=\"入住\" type=\"text\" id=\"cb_form_datefrom\" name=\"cb_form_datefrom\" value=\"2019/6/19\" />\r\n\t\t                </label>\r\n                        <a class=\"cp_cal_trig_from\" id=\"Citybreak_trigger_from\" title=\"入住\"></a>\r\n\t\t            </div>\r\n\t\t\t        <div class=\"cb_byline\" id=\"cb_accommodation_datefrom_byline\">&nbsp;</div>\r\n\t\t        </div>\r\n\t\t        <div class=\"cb_col_right\">\r\n\t\t\t        <label class=\"cb_titlelabel\">退房:</label>\r\n\t\t            <div class=\"cb_date_input\">\r\n\t\t                <label>\r\n                            <span class=\"cb_acc_dateto_label\" style=\"display: none\">\r\n                                <span class=\"cb_acc_dateto_day\"></span>\r\n                                <span class=\"cb_acc_dateto_month\"></span>\r\n                                <span class=\"cb_acc_dateto_year\"></span>\r\n                            </span>    \r\n                            <input title=\"退房\" type=\"text\" id=\"cb_form_dateto\" name=\"cb_form_dateto\" value=\"2019/6/26\" />\r\n\t\t                </label><a class=\"cp_cal_trig_from\" id=\"Citybreak_trigger_to\" title=\"退房\"></a>\r\n\t\t            </div>\t\t\t\t\t\t\r\n\t\t\t        <div class=\"cb_byline\" id=\"cb_accommodation_dateto_byline\">&nbsp;</div>\r\n\t\t        </div>\r\n\t        </div>\r\n\t    </div>\r\n</div>\r\n\r\n<div id=\"cb_acc_weekpicker_cnt\" class=\"cb_form_weekpicker_cont\" style=\"display: none;\">\r\n    <div>\r\n            <div class=\"cb_form_row cb_row_periodsearch\">\r\n                <span class=\"cb_main_formlabel\"><b>最新搜索类型:</b></span>\r\n                <div class=\"cb_radio\"><label><input name=\"cb-js-date-search-type\" type=\"radio\" checked value=\"0\" />日期搜索</label></div>\r\n                <div class=\"cb_radio\"><label><input name=\"cb-js-date-search-type\" type=\"radio\"  value=\"1\" />一周搜索</label></div>\r\n            </div>\r\n            <div id=\"cb-js-date-search\"  class=\"cb_form_row cb_form_chooseweek_cnt\">\r\n\t    \t<label class=\"cb_titlelabel\">日期:</label>\r\n                <div class=\"cb_selects cb_selects_wide\">\r\n                    <div class=\"cb_date_input\">\r\n                        <label>\r\n                            <input title=\"日期\" type=\"text\" id=\"cb_acc_weekpicker_date\" name=\"cb_form_dateinweek\" value=\"2019/6/19\"/>\r\n                        </label>\r\n                        <a class=\"cp_cal_trig_from\" id=\"Citybreak_trigger_dateinweek\" title=\"日期\"></a>\r\n                    </div>\r\n                </div>\r\n            </div>\r\n\r\n            <div id=\"cb-js-week-search\" class=\"cb_form_row cb_form_lenght_cnt\" style=\"display: none; padding-left: 0;\">\r\n                <label class=\"cb_titlelabel\">周:</label>\r\n                <div class=\"cb_selects cb_selects_wide\">\r\n\t\t\t\t\t<select class=\"cb-dropdown\" id=\"cb_acc_weekpicker_week\" name=\"CabinChangeWeekControl.DateForSelectedWeek\"><option value=\"2019/6/18\">周 25, 2019</option>\r\n<option value=\"2019/6/24\">周 26, 2019</option>\r\n<option value=\"2019/7/1\">周 27, 2019</option>\r\n<option value=\"2019/7/8\">周 28, 2019</option>\r\n<option value=\"2019/7/15\">周 29, 2019</option>\r\n<option value=\"2019/7/22\">周 30, 2019</option>\r\n<option value=\"2019/7/29\">周 31, 2019</option>\r\n<option value=\"2019/8/5\">周 32, 2019</option>\r\n<option value=\"2019/8/12\">周 33, 2019</option>\r\n<option value=\"2019/8/19\">周 34, 2019</option>\r\n<option value=\"2019/8/26\">周 35, 2019</option>\r\n<option value=\"2019/9/2\">周 36, 2019</option>\r\n<option value=\"2019/9/9\">周 37, 2019</option>\r\n<option value=\"2019/9/16\">周 38, 2019</option>\r\n<option value=\"2019/9/23\">周 39, 2019</option>\r\n<option value=\"2019/9/30\">周 40, 2019</option>\r\n<option value=\"2019/10/7\">周 41, 2019</option>\r\n<option value=\"2019/10/14\">周 42, 2019</option>\r\n<option value=\"2019/10/21\">周 43, 2019</option>\r\n<option value=\"2019/10/28\">周 44, 2019</option>\r\n<option value=\"2019/11/4\">周 45, 2019</option>\r\n<option value=\"2019/11/11\">周 46, 2019</option>\r\n<option value=\"2019/11/18\">周 47, 2019</option>\r\n<option value=\"2019/11/25\">周 48, 2019</option>\r\n<option value=\"2019/12/2\">周 49, 2019</option>\r\n<option value=\"2019/12/9\">周 50, 2019</option>\r\n<option value=\"2019/12/16\">周 51, 2019</option>\r\n<option value=\"2019/12/23\">周 52, 2019</option>\r\n<option value=\"2019/12/30\">周 1, 2020</option>\r\n<option value=\"2020/1/6\">周 2, 2020</option>\r\n<option value=\"2020/1/13\">周 3, 2020</option>\r\n<option value=\"2020/1/20\">周 4, 2020</option>\r\n<option value=\"2020/1/27\">周 5, 2020</option>\r\n<option value=\"2020/2/3\">周 6, 2020</option>\r\n<option value=\"2020/2/10\">周 7, 2020</option>\r\n<option value=\"2020/2/17\">周 8, 2020</option>\r\n<option value=\"2020/2/24\">周 9, 2020</option>\r\n<option value=\"2020/3/2\">周 10, 2020</option>\r\n<option value=\"2020/3/9\">周 11, 2020</option>\r\n<option value=\"2020/3/16\">周 12, 2020</option>\r\n<option value=\"2020/3/23\">周 13, 2020</option>\r\n<option value=\"2020/3/30\">周 14, 2020</option>\r\n<option value=\"2020/4/6\">周 15, 2020</option>\r\n<option value=\"2020/4/13\">周 16, 2020</option>\r\n<option value=\"2020/4/20\">周 17, 2020</option>\r\n<option value=\"2020/4/27\">周 18, 2020</option>\r\n<option value=\"2020/5/4\">周 19, 2020</option>\r\n<option value=\"2020/5/11\">周 20, 2020</option>\r\n<option value=\"2020/5/18\">周 21, 2020</option>\r\n<option value=\"2020/5/25\">周 22, 2020</option>\r\n<option value=\"2020/6/1\">周 23, 2020</option>\r\n<option value=\"2020/6/8\">周 24, 2020</option>\r\n<option value=\"2020/6/15\">周 25, 2020</option>\r\n<option value=\"2020/6/22\">周 26, 2020</option>\r\n<option value=\"2020/6/29\">周 27, 2020</option>\r\n<option value=\"2020/7/6\">周 28, 2020</option>\r\n<option value=\"2020/7/13\">周 29, 2020</option>\r\n<option value=\"2020/7/20\">周 30, 2020</option>\r\n<option value=\"2020/7/27\">周 31, 2020</option>\r\n<option value=\"2020/8/3\">周 32, 2020</option>\r\n<option value=\"2020/8/10\">周 33, 2020</option>\r\n<option value=\"2020/8/17\">周 34, 2020</option>\r\n<option value=\"2020/8/24\">周 35, 2020</option>\r\n<option value=\"2020/8/31\">周 36, 2020</option>\r\n<option value=\"2020/9/7\">周 37, 2020</option>\r\n<option value=\"2020/9/14\">周 38, 2020</option>\r\n<option value=\"2020/9/21\">周 39, 2020</option>\r\n<option value=\"2020/9/28\">周 40, 2020</option>\r\n<option value=\"2020/10/5\">周 41, 2020</option>\r\n<option value=\"2020/10/12\">周 42, 2020</option>\r\n<option value=\"2020/10/19\">周 43, 2020</option>\r\n<option value=\"2020/10/26\">周 44, 2020</option>\r\n<option value=\"2020/11/2\">周 45, 2020</option>\r\n<option value=\"2020/11/9\">周 46, 2020</option>\r\n<option value=\"2020/11/16\">周 47, 2020</option>\r\n<option value=\"2020/11/23\">周 48, 2020</option>\r\n<option value=\"2020/11/30\">周 49, 2020</option>\r\n<option value=\"2020/12/7\">周 50, 2020</option>\r\n<option value=\"2020/12/14\">周 51, 2020</option>\r\n<option value=\"2020/12/21\">周 52, 2020</option>\r\n<option value=\"2020/12/28\">周 1, 2021</option>\r\n<option value=\"2021/1/4\">周 2, 2021</option>\r\n<option value=\"2021/1/11\">周 3, 2021</option>\r\n<option value=\"2021/1/18\">周 4, 2021</option>\r\n<option value=\"2021/1/25\">周 5, 2021</option>\r\n<option value=\"2021/2/1\">周 6, 2021</option>\r\n<option value=\"2021/2/8\">周 7, 2021</option>\r\n<option value=\"2021/2/15\">周 8, 2021</option>\r\n<option value=\"2021/2/22\">周 9, 2021</option>\r\n<option value=\"2021/3/1\">周 10, 2021</option>\r\n<option value=\"2021/3/8\">周 11, 2021</option>\r\n<option value=\"2021/3/15\">周 12, 2021</option>\r\n<option value=\"2021/3/22\">周 13, 2021</option>\r\n<option value=\"2021/3/29\">周 14, 2021</option>\r\n<option value=\"2021/4/5\">周 15, 2021</option>\r\n<option value=\"2021/4/12\">周 16, 2021</option>\r\n<option value=\"2021/4/19\">周 17, 2021</option>\r\n<option value=\"2021/4/26\">周 18, 2021</option>\r\n<option value=\"2021/5/3\">周 19, 2021</option>\r\n<option value=\"2021/5/10\">周 20, 2021</option>\r\n<option value=\"2021/5/17\">周 21, 2021</option>\r\n<option value=\"2021/5/24\">周 22, 2021</option>\r\n<option value=\"2021/5/31\">周 23, 2021</option>\r\n<option value=\"2021/6/7\">周 24, 2021</option>\r\n<option value=\"2021/6/14\">周 25, 2021</option>\r\n<option value=\"2021/6/21\">周 26, 2021</option>\r\n<option value=\"2021/6/28\">周 27, 2021</option>\r\n<option value=\"2021/7/5\">周 28, 2021</option>\r\n<option value=\"2021/7/12\">周 29, 2021</option>\r\n<option value=\"2021/7/19\">周 30, 2021</option>\r\n<option value=\"2021/7/26\">周 31, 2021</option>\r\n<option value=\"2021/8/2\">周 32, 2021</option>\r\n<option value=\"2021/8/9\">周 33, 2021</option>\r\n<option value=\"2021/8/16\">周 34, 2021</option>\r\n<option value=\"2021/8/23\">周 35, 2021</option>\r\n<option value=\"2021/8/30\">周 36, 2021</option>\r\n<option value=\"2021/9/6\">周 37, 2021</option>\r\n<option value=\"2021/9/13\">周 38, 2021</option>\r\n<option value=\"2021/9/20\">周 39, 2021</option>\r\n<option value=\"2021/9/27\">周 40, 2021</option>\r\n<option value=\"2021/10/4\">周 41, 2021</option>\r\n<option value=\"2021/10/11\">周 42, 2021</option>\r\n<option value=\"2021/10/18\">周 43, 2021</option>\r\n<option value=\"2021/10/25\">周 44, 2021</option>\r\n<option value=\"2021/11/1\">周 45, 2021</option>\r\n<option value=\"2021/11/8\">周 46, 2021</option>\r\n<option value=\"2021/11/15\">周 47, 2021</option>\r\n<option value=\"2021/11/22\">周 48, 2021</option>\r\n<option value=\"2021/11/29\">周 49, 2021</option>\r\n<option value=\"2021/12/6\">周 50, 2021</option>\r\n<option value=\"2021/12/13\">周 51, 2021</option>\r\n<option value=\"2021/12/20\">周 52, 2021</option>\r\n</select>\r\n                </div>\r\n            </div>\r\n\r\n            <div class=\"cb_form_row cb_form_lenght_cnt\" >\r\n                <label class=\"cb_titlelabel\">长度:</label>\r\n\t\t\t\t<div class=\"cb_selects cb_selects_wide\">\r\n\t\t\t\t\t\r\n\t\t\t\t\t<select id=\"cb_acc_weekpicker_period\" name=\"cb_searchPeriod\" title=\"长度\">\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t<option value=\"sp-1\" >\r\n\t\t\t\t\t\t\t\tWeek\r\n\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t<option value=\"sp-2\" >\r\n\t\t\t\t\t\t\t\tShort week\r\n\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t<option value=\"sp-3\" >\r\n\t\t\t\t\t\t\t\tWeekend\r\n\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t<option value=\"hc-nights\" >\r\n\t\t\t\t\t\t\t\t夜\r\n\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t</select>\r\n\t\t\t\t</div>\r\n            </div>\r\n\r\n        </div>\r\n</div>\r\n\r\n\r\n\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row\" id=\"cb_acc_nodates_cnt\">\r\n\t<div class=\"cb_checkbox\">\r\n\t\t<label>\r\n            <input title=\"我没有具体日期\" type=\"checkbox\" name=\"cb_nodates\" id=\"cb_nodates\" value=\"true\"  />\r\n            <span class=\"cb_checkbox_lbl\">我没有具体日期</span>\r\n\t\t</label>\r\n\t</div>\r\n</div>\r\n                                \r\n                           \r\n\r\n\r\n<div id=\"cb_acc_typeofguestsearch_cnt\" style=\"display: none;\">\r\n\t<div class=\"cb_form_row\">\r\n\t\r\n\t    <label class=\"cb_main_formlabel\">预约类型:</label>\r\n\t\t\r\n\t    <div class=\"cb_radio\">\r\n\t        <label>\r\n\t            <input title=\"本书的床\" name=\"cb_acc_typeofguestsearch\" type=\"radio\" value=\"beds\" id=\"cb_acc_typeofguestsearch_beds\"/>\r\n\t            <span class=\"cb_radio_lbl\">本书的床</span>\r\n\t        </label>\t\t\t\r\n\t    </div>\r\n\r\n\t\t<div class=\"cb_radio\">\r\n\t\t\t<label>\r\n\t\t\t\t<input title=\"客房预订\" name=\"cb_acc_typeofguestsearch\" type=\"radio\" value=\"rooms\" id=\"cb_acc_typeofguestsearch_rooms\" checked=\"checked\" />\r\n\t\t\t\t<span class=\"cb_radio_lbl\">客房预订</span>\r\n\t\t\t</label>\t\t\r\n\t\t</div>\r\n\r\n\t</div>\r\n</div>\r\n\r\n<div id=\"cb_form_guests_cont\">\r\n\t<div id=\"cb_form_beds_cont\" style=\"display: none;\">\r\n            <div id=\"cb_form_beds_moveme\">\r\n                <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n                    <label class=\"cb_titlelabel\">\r\n                        宾客:\r\n                    </label>\r\n                    <div class=\"cb_col_left\">\r\n                        <select id=\"cb_bed_numadults\" name=\"cb_bed_numadults\" title=\"成人\">\r\n                                    <option value=\"1\" >\r\n                                        1 成人\r\n                                    </option>\r\n                                    <option value=\"2\" selected=&quot;selected&quot;>\r\n                                        2 成人\r\n                                    </option>\r\n                                    <option value=\"3\" >\r\n                                        3 成人\r\n                                    </option>\r\n                                    <option value=\"4\" >\r\n                                        4 成人\r\n                                    </option>\r\n                                    <option value=\"5\" >\r\n                                        5 成人\r\n                                    </option>\r\n                                    <option value=\"6\" >\r\n                                        6 成人\r\n                                    </option>\r\n                                    <option value=\"7\" >\r\n                                        7 成人\r\n                                    </option>\r\n                                    <option value=\"8\" >\r\n                                        8 成人\r\n                                    </option>\r\n                                    <option value=\"9\" >\r\n                                        9 成人\r\n                                    </option>\r\n                                    <option value=\"10\" >\r\n                                        10 成人\r\n                                    </option>\r\n                                    <option value=\"11\" >\r\n                                        11 成人\r\n                                    </option>\r\n                                    <option value=\"12\" >\r\n                                        12 成人\r\n                                    </option>\r\n                                    <option value=\"13\" >\r\n                                        13 成人\r\n                                    </option>\r\n                                    <option value=\"14\" >\r\n                                        14 成人\r\n                                    </option>\r\n                                    <option value=\"15\" >\r\n                                        15 成人\r\n                                    </option>\r\n                                    <option value=\"16\" >\r\n                                        16 成人\r\n                                    </option>\r\n                                    <option value=\"17\" >\r\n                                        17 成人\r\n                                    </option>\r\n                                    <option value=\"18\" >\r\n                                        18 成人\r\n                                    </option>\r\n                                    <option value=\"19\" >\r\n                                        19 成人\r\n                                    </option>\r\n                                    <option value=\"20\" >\r\n                                        20 成人\r\n                                    </option>\r\n                        </select>\r\n                    </div>\r\n                    <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n                        <select id=\"cb_bed_numchild\" onchange=\"citybreakAccommodationSearchForm.onBedChildChange()\" title=\"孩子\">\r\n                                    <option value=\"0\" selected=&quot;selected&quot;>\r\n                                        0 孩子\r\n                                    </option>\r\n                                    <option value=\"1\" >\r\n                                        1 孩子\r\n                                    </option>\r\n                                    <option value=\"2\" >\r\n                                        2 孩子\r\n                                    </option>\r\n                                    <option value=\"3\" >\r\n                                        3 孩子\r\n                                    </option>\r\n                                    <option value=\"4\" >\r\n                                        4 孩子\r\n                                    </option>\r\n                        </select>\r\n                    </div>\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_bed_childage_cont\">\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_bed_childage1\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_bed_childage1\" name=\"cb_bed_childage1\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_bed_childage2\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_bed_childage2\" name=\"cb_bed_childage2\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_bed_childage3\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_bed_childage3\" name=\"cb_bed_childage3\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_bed_childage4\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_bed_childage4\" name=\"cb_bed_childage4\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n\t</div>\r\n    \r\n    <div id=\"cb_form_rooms_cont\" >\r\n        <div id=\"cb_acc_numrooms_cnt\" class=\"cb_ac_section_numrooms cb_form_row\">\r\n            <label class=\"cb_titlelabel\">\r\n                房间数:</label>\r\n            <div class=\"cb_selects cb_selects_w3\">\r\n                <select id=\"cb_numrooms\" onchange=\"citybreakAccommodationSearchForm.cb_onRoomChange();\" title=\"房间数\">\r\n                        <option value=\"1\" >\r\n                            1 房间\r\n                        </option>\r\n                        <option value=\"2\" >\r\n                            2 客房\r\n                        </option>\r\n                        <option value=\"3\" >\r\n                            3 客房\r\n                        </option>\r\n                        <option value=\"4\" >\r\n                            4 客房\r\n                        </option>\r\n                        <option value=\"5\" >\r\n                            5 客房\r\n                        </option>\r\n                </select>\r\n            </div>\r\n        </div>\r\n\r\n            <div id=\"cb_form_room1\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd1\">\r\n                    <input title=\"房间 1\" type=\"checkbox\" checked=&quot;checked&quot; class=\"cb_room_toggle\" name=\"cb_room1\" />\r\n                    房间 1\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults1\" name=\"cb_numadults1\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild1\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(1)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont1\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage11\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage11\" name=\"cb_childage11\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage12\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage12\" name=\"cb_childage12\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage13\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage13\" name=\"cb_childage13\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage14\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage14\" name=\"cb_childage14\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n            <div id=\"cb_form_room2\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd2\">\r\n                    <input title=\"房间 2\" type=\"checkbox\"  class=\"cb_room_toggle\" name=\"cb_room2\" />\r\n                    房间 2\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults2\" name=\"cb_numadults2\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild2\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(2)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" >\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont2\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage21\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage21\" name=\"cb_childage21\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage22\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage22\" name=\"cb_childage22\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage23\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage23\" name=\"cb_childage23\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage24\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage24\" name=\"cb_childage24\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n            <div id=\"cb_form_room3\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd3\">\r\n                    <input title=\"房间 3\" type=\"checkbox\"  class=\"cb_room_toggle\" name=\"cb_room3\" />\r\n                    房间 3\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults3\" name=\"cb_numadults3\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild3\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(3)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" >\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont3\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage31\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage31\" name=\"cb_childage31\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage32\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage32\" name=\"cb_childage32\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage33\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage33\" name=\"cb_childage33\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage34\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage34\" name=\"cb_childage34\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n            <div id=\"cb_form_room4\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd4\">\r\n                    <input title=\"房间 4\" type=\"checkbox\"  class=\"cb_room_toggle\" name=\"cb_room4\" />\r\n                    房间 4\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults4\" name=\"cb_numadults4\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild4\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(4)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" >\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont4\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage41\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage41\" name=\"cb_childage41\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage42\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage42\" name=\"cb_childage42\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage43\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage43\" name=\"cb_childage43\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage44\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage44\" name=\"cb_childage44\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n            <div id=\"cb_form_room5\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd5\">\r\n                    <input title=\"房间 5\" type=\"checkbox\"  class=\"cb_room_toggle\" name=\"cb_room5\" />\r\n                    房间 5\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults5\" name=\"cb_numadults5\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild5\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(5)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" >\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont5\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage51\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage51\" name=\"cb_childage51\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage52\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage52\" name=\"cb_childage52\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage53\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage53\" name=\"cb_childage53\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage54\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage54\" name=\"cb_childage54\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n    </div>\r\n\r\n    <div id=\"cb_form_rooms_group_cnt\" style=\"display: none;\">\r\n        <div id=\"cb_acc_numsinglerooms_group_cnt\" class=\"cb_ac_section_numsinglerooms cb_form_row\">\r\n            <label class=\"cb_titlelabel\">\r\n                号。单人间:</label>\r\n            <div class=\"cb_selects cb_selects_w3\">\r\n                <select id=\"cb_numsinglerooms_group\" title=\"号。单人间\">\r\n                        <option value=\"0\" selected=&quot;selected&quot;>\r\n                            0 客房\r\n                        </option>\r\n                        <option value=\"1\" >\r\n                            1 房间\r\n                        </option>\r\n                        <option value=\"2\" >\r\n                            2 客房\r\n                        </option>\r\n                        <option value=\"3\" >\r\n                            3 客房\r\n                        </option>\r\n                        <option value=\"4\" >\r\n                            4 客房\r\n                        </option>\r\n                        <option value=\"5\" >\r\n                            5 客房\r\n                        </option>\r\n                </select>\r\n            </div>\r\n        </div>\r\n        \r\n        <div id=\"cb_acc_numdoublerooms_group_cnt\" class=\"cb_ac_section_numdoublerooms cb_form_row\">\r\n            <label class=\"cb_titlelabel\">\r\n                号。双人间:</label>\r\n            <div class=\"cb_selects cb_selects_w3\">\r\n                <select id=\"cb_numdoublerooms_group\" title=\"号。双人间\">\r\n                        <option value=\"0\" >\r\n                            0 客房\r\n                        </option>\r\n                        <option value=\"1\" selected=&quot;selected&quot;>\r\n                            1 房间\r\n                        </option>\r\n                        <option value=\"2\" >\r\n                            2 客房\r\n                        </option>\r\n                        <option value=\"3\" >\r\n                            3 客房\r\n                        </option>\r\n                        <option value=\"4\" >\r\n                            4 客房\r\n                        </option>\r\n                        <option value=\"5\" >\r\n                            5 客房\r\n                        </option>\r\n                </select>\r\n            </div>\r\n        </div>\r\n    </div>\r\n</div>\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_showas_radiolist\">\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t\t<input name=\"cb_showon\" type=\"radio\" value=\"list\" id=\"cb_acc_showon_list\" checked=\"checked\" title=\"显示列表\" />\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_icon cb_showaslist\" title=\"显示列表\"></span>\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">在列表中显示结果</span>\r\n\t\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"cb_showon\" value=\"map\" id=\"cb_acc_showon_map\" title=\"显示地图\" />\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_icon cb_showasmap\" title=\"显示地图\"></span>\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">在地图上显示结果</span>\r\n\t\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\r\n\t\t\t\t\t\t<div class=\"cb_btn cb_clr\">\r\n\t\t\t\t\t\t\t<a href=\"#\" class=\"Citybreak_Button cb_searchbutton\" id=\"CB_SearchButton\" title=\"住宿搜索\">住宿搜索</a>\r\n\t\t\t\t\t\t\t<a href=\"#\" class=\"Citybreak_Button cb_searchbutton\" id=\"CB_SearchButtonNodates\" title=\"住宿搜索\">住宿搜索</a>\r\n\t\t\t\t\t\t\t<input type=\"submit\" value=\"住宿搜索\" id=\"cb_ns_submitbtn\" class=\"cb_ns_submitbtn\" title=\"住宿搜索\" />\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n</form>\t\t\t</div>\r\n\t\t\t<div class=\"cb_ft\"></div>\r\n\t\t</div>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_accommodation_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_accommodation_searchform_widget, executing inline widget scripts');





                var accommodationUrls = {};
                var accommodationSearchLocalizedTexts = {};
                (function ($, accommodationUrls, accommodationSearchLocalizedTexts, undefined) {
                    citybreakjq("#cb_acc_wheredoyouwanttostay_cnt").removeClass('cb_hidden');

                    citybreakjq.extend(accommodationUrls, {
                        'whereDoYouWantToGoJSON': 'http://online3-next.citybreak.com/537027515/zh/accommodation/wheredoyouwanttogo',
                        'whereDoYouWantToGoFilterUrl': 'http://online3-next.citybreak.com/537027515/zh/where-do-you-want-to-go/accommodationfilter',
                        'whereDoYouWantToGoSearchUrl': 'http://online3-next.citybreak.com/537027515/zh/where-do-you-want-to-go/accommodationsearch'
                    });

                    citybreakjq.extend(accommodationSearchLocalizedTexts, {
                        'AutoCompleteByLineTheresMore': '还有更多的结果',
                        'AutoCompleteNoResults': '0匹配。',
                        'AutoCompleteResultPointOfInterestCategory': '地标'
                    });


                })(citybreakjq, accommodationUrls, accommodationSearchLocalizedTexts);
                (function ($, undefined) {
                    $("#cb_accommodationtype").data("categoryRelations", [{ "Name": "Deluxe Chalets", "Id": 32542, "Relations": 0 }, { "Name": "Hotel", "Id": 16616, "Relations": 0 }, { "Name": "Residence", "Id": 16617, "Relations": 0 }, { "Name": "Self-catered apartment", "Id": 16620, "Relations": 0 }, { "Name": "UCPA youth hostel ", "Id": 27621, "Relations": 0 }, { "Name": "所有", "Id": 16615, "Relations": 0 }]);

                })(citybreakjq);
                (function ($, accommodationUrls, accommodationSearchLocalizedTexts, undefined) {


                    citybreakjq('#cb_ns_submitbtn').css('display', 'none');

                    citybreakjq.extend(accommodationUrls, {
                        'newSearch': 'http://online3-next.citybreak.com/537027515/zh/accommodationsearch/search',
                        'newFilter': 'http://online3-next.citybreak.com/537027515/zh/accommodationsearch/filter'
                    });

                    var fallbackFormComponents = 119;
                    var categoryToFormComponents = { "16615": 55, "16616": 55, "16617": 55, "16620": 55, "27621": 55, "32542": 55 };
                    var allCategoriesMapped = { "16615": { "CategoryId": 16615, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "16616": { "CategoryId": 16616, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "16617": { "CategoryId": 16617, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "16620": { "CategoryId": 16620, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "27621": { "CategoryId": 27621, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "32542": { "CategoryId": 32542, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" } };

                    var validationMessages = {};

                    validationMessages.InvalidGeoNodeOption = "Invalid geonode selected";
                    validationMessages.InvalidCheckInDate = "无效的入住日期";
                    validationMessages.InvalidCheckOutDate = "无效的退房日期";

                    validationMessages.CheckInDateHasPassed = "入住日期已过";
                    validationMessages.CheckOutDateHasPassed = "退房日期已过";

                    validationMessages.CheckOutDateShouldBeGreaterThanCheckinDate = "入住日期必须在退房日期前";

                    validationMessages.GroupRoomBookingOneRoomRequired = "At least one room is required";
                    validationMessages.GroupRoomBookingPleaseSelectAtMostRooms = "Please select 5 rooms";
                    validationMessages.GroupRoomBookingTooManyRooms = "To many rooms selected 5";
                    validationMessages.InvalidChildAges = "有效的婴儿年龄为0到17年";
                    validationMessages.PleaseFillInChildAges = "请填写每个儿童的年龄";
                    validationMessages.PleaseChooseWhereDoYouWantToGoOrLeaveEmpty = "类型目的地城市或地标";
                    validationMessages.InvalidPromotionCode = '无效';
                    validationMessages.InvalidSearchCharacter = "Invalid search character";

                    validationMessages.Day = "夜";
                    validationMessages.Days = "夜";
                    validationMessages.CookieAlert = "Warning! Cookies are disabled. ";

                    var accCfg = citybreakCommonSearchForm.getAccommodationSearchConfiguration(
                        new Date(2019, 5, 19, 0, 0, 0, 0),
                        new Date(2019, 5, 26, 0, 0, 0, 0),
                        "2",
                        16615,
                        new Date(2019, 5, 19, 0, 0, 0, 0)
                    );

                    var filterSettings = {};

                    filterSettings.isLockedByCategory = false;



                    filterSettings.categoryId = 16615;



                    var validationSettings = {};
                    validationSettings.RequireWhereDoYouWantToGo = false;
                    validationSettings.MaximumChildAge = 17;
                    validationSettings.MinimumChildAge = 0;

                    var optionSettings = {};
                    optionSettings.MaxNumberOfRooms = 5;
                    optionSettings.MaxNumberOfChildren = 5;
                    optionSettings.minDays = 1;
                    optionSettings.minDate = new Date(2019, 5, 19, 0, 0, 0, 0);
                    optionSettings.selectedDate = new Date(2019, 5, 19, 0, 0, 0, 0);
                    optionSettings.AddNumberOfDays = 7;
                    optionSettings.ShowPromoCodeField = false;
                    optionSettings.PromotionCode = '';
                    optionSettings.ValidatePromotionCodeUrl = 'http://online3-next.citybreak.com/537027515/zh/accommodationsearch/isvalidpromotioncode';
                    optionSettings.ShowGeoDropdown = false;
                    optionSettings.AllowFreetextToggle = false;
                    optionSettings.ToggleTextHtml = { freetext: '', geo: '' };



                    var searchFormUrlOverrides = {};

                    var accommodationRoomConfigOptions = {
                        minChildAge: 0,
                        maxChildAge: 17,
                        maxNoRooms: 5,
                        maxNoAdults: 20,
                        maxNoChildren: 5,
                        maxNoTotalPersons: undefined,
                        validationMessages: {
                            invalidNumberOfRooms: "Invalid number of rooms",
                            invalidNumberOfAdults: "Invalid number of adults",
                            invalidNumberOfChildren: "Invalid number of children",
                            invalidChildAge: "Specify age of children",
                            invalidNumberOfTotalPersons: "You can only search for max {0} persons at a time."
                        },
                        translations: {
                            room: "房间",
                            rooms: "客房",
                            person: "人",
                            persons: "人",
                            adult: "成人",
                            adults: "成人",
                            child: "孩子",
                            children: "孩子",
                            removeRoom: "清除",
                            addRoom: "添加房间",
                            done: "做",
                            cancel: "取消",
                            agesOfChildren: "儿童的年龄（0  -  17岁）",
                            cabin: "cabin"
                        },
                        placementRequests: [{ "IsEmpty": false, "IsValid": true, "Adults": 2, "Children": [] }]
                    };

                    citybreakAccommodationSearchForm.initializeSearchForm(
                    fallbackFormComponents,
                    categoryToFormComponents,
                    allCategoriesMapped,
                    validationMessages,
                    accCfg.arrivalDate,
                    accCfg.departureDate,
                    0,
                    accCfg.roomCfg,
                    accommodationUrls,
                    true,
                    accommodationSearchLocalizedTexts,
                    "",
                    validationSettings,
                    filterSettings,
                    optionSettings,
                    searchFormUrlOverrides,
                    "地区，地标或财产",
                    accommodationRoomConfigOptions
                    );


                    citybreakjq('#cb_sort_search').data('default_value', '名称');


                })(citybreakjq, accommodationUrls, accommodationSearchLocalizedTexts);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_accommodation_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_accommodation_searchform_widget, executing');

            var target = citybreakjq('#citybreak_accommodation_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_accommodation_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_accommodation_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_accommodation_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_accommodation_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_activity_booking_widget', function () {
            console.log('onContentReady #citybreak_activity_booking_widget, executing');

            var target = document.getElementById('citybreak_activity_booking_widget');

            if (!target) {
                console.log('onContentReady #citybreak_activity_booking_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_activity_booking_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_activity_booking_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_activity_booking_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_activity_booking_widget, executing inline widget scripts');





                (function ($, undefined) {
                    var activityGroupAlternativesTemplate = '' +
                        '<div class="cb_js_loading" style="display: none;"><table><tbody><tr><td><div class="cb-loading-block"><span></span></div></td></tr></tbody></table></div>' +
                        '{{#products}}' +
                            '<div class="cb-row cb_js_product">' +
                                '<table>' +
                                    '<tbody>' +
                                        '<tr>' +
                                            '<td class="cb-cell-product">' +
                                                '<div class="cb-inner cb_clr">' +
                                                    '<div class="cb-cnt-smalldescr">' +
                                                        '{{#ImageUrl}}' +
                                                            '<div class="cb-column cb-column-photo">' +
                                                                '<span class="cb-image-thumb"><img src="{{ImageUrl}}" /></span>' +
                                                            '</div>' +
                                                        '{{/ImageUrl}}' +
                                                        '<div class="cb-column cb-js-activity-product-alternative">' +
                                                            '<a class="cb-iconlnk cb_js_activity_detail_link" href="javascript:void(0);">' +
                                                                '<span class="cb-bullet"><span class="cb-icon-tiny-info"></span></span>' +
                                                                '{{Name}}' +
                                                            '</a><br/>' +
                                                            '{{#BookSettings.HasStart}}' +
                                                            '<i>{{StartDateTranslation}}: {{StartDate}}</i>' +
                                                            '{{/BookSettings.HasStart}}' +
                                                            '<p class="cb-hidden">{{{ShortDescriptionWithFallBack}}}</p>' +
                                                            '<div class="cb_js_inline_content" id="cb_inline_content_{{productKey}}" style="display:none; padding: 10px;">' +
                                                                '<div class="cb-page-title cb-clr">' +
                                                                    '<h1 class="cb-title-small">{{Name}}</h1>' +
                                                                '</div>' +
                                                                '<div class="cb-product-description">' +
                                                                    '<div class="cb-product-inner">' +
                                                                        '<div class="cb-column cb-column-photo"><div class="cb-image" style="background-image: url({{BigImageUrl}})"><img src="{{BigImageUrl}}" alt="{{AltText}}"/></div></div>' +
                                                                        '<div class="cb-column"><p>{{{ShortDescription}}}</p><p style="white-space: pre-wrap">{{{Description}}}</p></div>' +
                                                                    '</div>' +
                                                                '</div>' +
                                                            '</div>' +
                                                        '</div>' +
                                                    '</div>' +
                                                '</div>' +
                                            '</td>' +
                                            '<td class="cb-cell-choose">' +
                                                '<table>' +
                                                     '{{#BookSettings.HasDuration}}' +
                                                        '<tbody class="cb-row-duration">' +
                                                            '<tr class="cb-row-duration">' +
                                                            '{{#multirowAlternatives}}' +
                                                                '<td class="cb-cell-pricegroup" colspan="2">' +
                                                                     '{{#alternativeText}}' +
                                                                        '<span class="cb-inner">' +
                                                                            '<b>{{alternativeText}}:</b>' +
                                                                        '</span>' +
                                                                     '{{/alternativeText}}' +
                                                                        '<span class="cb-activity-booking-message cb_few_left">{{BookingMessage}}</span>' +
                                                                '</td>' +
                                                                '<td class="cb-cell-quantity">' +
                                                                    '<span class="cb-inner">' +
                                                                         '{{#AlternativeDescription}}' +
                                                                                '<span class="cb-icnlbl cb-icnlbl-time"><b>{{AlternativeDescription}}</b> <span class="cb-nowrap">{{Duration}}</span></span>' +
                                                                         '{{/AlternativeDescription}}' +
                                                                    '</span>' +
                                                                '</td>' +
                                                            '{{/multirowAlternatives}}' +
                                                            '{{#showDropdownAlternatives?}}' +
                                                                '<td class="cb-cell-pricegroup" colspan="2">' +
                                                                    '<span class="cb-inner">' +
                                                                        '<b>{{chooseAlternativeText}}:</b>' +
                                                                    '</span>' +
                                                                     '<span class="cb-activity-booking-message cb_few_left">{{BookingMessage}}</span>' +
                                                                '</td>' +
                                                                '<td class="cb-cell-quantity">' +
                                                                    '<span class="cb-inner">' +
                                                                        '<select data-cbisproductid="{{cbisProductId}}" data-productkey="{{productKey}}" class="cb-form-select cb_js_select_alternative">' +
                                                                            '{{#showSelectAlternativeOption?}}<option value="-1"></option>{{/showSelectAlternativeOption?}}' +
                                                                            '{{#dropdownAlternatives}}' +
                                                                                '<option value="{{alternativeKey}}">{{AlternativeDescription}} {{Duration}}</option>' +
                                                                            '{{/dropdownAlternatives}}' +
                                                                        '</select>' +
                                                                    '</span>' +
                                                                '</td>' +
                                                            '{{/showDropdownAlternatives?}}' +
                                                            '</tr>' +
                                                        '</tbody>' +
                                                     '{{/BookSettings.HasDuration}}' +
                                                    '<tbody class="cb_js_alternative_pricegroup_{{productKey}}">' +
                                                        '<tr>' +
                                                            '<td class="cb-cell-pricegroup"><span class="cb-inner"></span></td>' +
                                                            '<td class="cb-cell-pricing"><span class="cb-inner"></span></td>' +
                                                            '<td class="cb-cell-quantity"><span class="cb-inner"></span></td>' +
                                                        '</tr>' +
                                                    '</tbody>' +
                                                '</table>' +
                                            '</td>' +
                                        '</tr>' +
                                    '</tbody>' +
                                '</table>' +
                            '</div>' +
                        '{{/products}}' +
                    ''; var alternativeBookingMessageTemplate = '' +
                    '{{#bookingMessage}}' +
                        '<div>{{bookingMessage}}</div>' +
                    '{{/bookingMessage}}' +
                    '';

                    var alternativePriceGroupTemplate = '' +
                        '{{#priceGroups}}' +
                            '{{#priceGroup?}}' +
                            '<tr>' +
                                '<td class="cb-cell-pricegroup">' +
                                    '<span class="cb-inner">' +
                                        '{{Name}}:' +
                                    '</span>' +
                                '</td>' +
                                '<td class="cb-cell-pricing">' +
                                    '<span class="cb-inner">' +
                                        '<b class="cb-price">{{Price}} {{Currency}}</b>' +
                                    '</span>' +
                                '</td>' +
                                '<td class="cb-cell-quantity">' +
                                    '<span class="cb-inner">' +
                                        '<select data-cbisproductid="{{cbisProductId}}" data-productkey="{{productKey}}" data-bookkey="{{BookKey}}" data-price="{{Price}}" class="cb-form-select cb_js_select_pricegroup">' +
                                            '<option value="0">{{noneText}}</option>' +
                                            '{{#quantities}}' +
                                                '<option value="{{quantity}}">×{{quantity}} ({{amount}} {{Currency}})</option>' +
                                            '{{/quantities}}' +
                                        '</select>' +
                                    '</span>' +
                                '</td>' +
                            '</tr>' +
                            '{{/priceGroup?}}' +
                        '{{/priceGroups}}' +
                    '';
                    var activityWidgetTemplate = '<div class="Citybreak_engine cb-widget-activity cb-product-single">' +
                '<a style="display: none;" class="cb-btn cb-js-trigger-btn">{{translations.bookTranslation}}</a>' +
                '<div class="cb-padding cb-js-trigger-container">' +
                    '<div class="cb-tbl">' +
                        '<div class="cb-row">' +
                            '<div class="cb-cell cb-cell-date cb-js-calendar-wrapper">' +
                                '<div class="cb-inner">' +
                                    '<h3>1. {{translations.dateForBookingTranslation}}</h3>' +
                                    '<div class="cb-cal-title" style="display: none">' +
                                        '<div>{{translations.chooseDateTranslation}}:</div>' +
                                        '<label class="cb-form-icon cb-icon-date cb-js-hotel-date-input" id="">' +
                                            '<span class="cb-form-text"></span>' +
                                        '</label>' +
                                    '</div>' +
                                    '<div class="cb-popout cb-datepicker cb-gui-datepicker cb-availability cb-lip-top">' +
                                        '<div class="cb-popout-content">' +
                                            '<div class="cb_js_activity_datepicker cb_validate_startdate cb_validate_required" name="cb_start" type="text" />' +
                                            '<div class="cb-legends">' +
                                                '<span class="cb-legend cb-avail">{{translations.availableTranslation}}</span>' +
                                                '<span class="cb-legend cb-selected" style="display: none;">{{translations.selectedDateTranslation}}</span>' +
                                                '<span class="cb-legend cb-fully-booked">{{translations.notSelectableTranslation}}</span>' +
                                            '</div>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<div class="cb-cell cb-cell-config">' +
                                '<div class="cb-inner">' +
                                    '<div class="cb-message cb-message-default cb-js-date-preselection"><span class="cb-arrow"></span><p>{{translations.chooseDateTranslation}}</p></div>' +
                                    '<div class="cb_js_activity_template_container" style="display: none;">' +
                                        '<div class="cb_js_loading cb-loading-block">' +
                                            '{{translations.loadingTranslation}}' +
                                        '</div>' +
                                        '<div class="cb-rows cb_js_no_availability" style="display: none;">' +
                                            '<p>{{translations.noAvailabilityTranslation}}</p>' +
                                        '</div>' +
                                    '</div>' +

                                    '<div class="cb_js_select_product_container">' +
                                    '</div>' +

                                    '<div class="cb-total cb_js_total_price_container" style="display: none;">' +
                                        '<h3>' +
                                            '<span>{{translations.totalPriceTranslation}}:&nbsp;</span>' +
                                            '<span>' +
                                            '<span class="cb-price cb_js_total_price"></span>&nbsp;' +
                                            '<span class="cb-price cb_js_total_price_currency"></span>' +
                                            '</span>' +
                                        '</h3>' +
                                        '<a class="cb-btn cb-icon-right cb_js_book_button">' +
                                            '{{translations.bookTranslation}}' +
                                            '<span class="cb-icon-app cb-icon-arrow-right-alt"></span>' +
                                        '</a>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>';
                    var activityGroupWidgetTemplate = '<div class="Citybreak_engine cb-widget-activity cb-product-group cb-js-activity-booking-container">' +
                '<a style="display: none;" class="cb-btn cb-js-trigger-btn">{{translations.bookTranslation}}</a>' +
                '<div class="cb-padding cb-js-trigger-container">' +
                    '<div class="cb-tbl">' +
                        '<div class="cb-row">' +
                            '<div class="cb-cell cb-cell-date cb-js-calendar-wrapper">' +
                                '<div class="cb-inner">' +
                                    '<h3>1. {{translations.dateForBookingTranslation}}</h3>' +
                                    '<div class="cb-cal-title" style="display: none">' +
                                        '<div>{{translations.chooseDateTranslation}}:</div>' +
                                        '<label class="cb-form-icon cb-icon-date cb-js-hotel-date-input" id="">' +
                                            '<span class="cb-form-text"></span>' +
                                        '</label>' +
                                    '</div>' +
                                    '<div class="cb-popout cb-datepicker cb-gui-datepicker cb-availability cb-lip-top">' +
                                        '<div class="cb-popout-content">' +
                                            '<div class="cb_js_activity_datepicker cb_validate_startdate cb_validate_required" name="cb_start" type="text" />' +
                                            '<div class="cb-legends">' +
                                                '<span class="cb-legend cb-avail">{{translations.availableTranslation}}</span>' +
                                                '<span class="cb-legend cb-selected" style="display: none;">{{translations.selectedDateTranslation}}</span>' +
                                                '<span class="cb-legend cb-fully-booked">{{translations.notSelectableTranslation}}</span>' +
                                            '</div>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<div class="cb-cell cb-cell-config">' +
                                '<div class="cb-inner">' +
                                    '<div class="cb-message cb-message-default cb-js-date-preselection"><span class="cb-arrow"></span><p>{{translations.chooseDateTranslation}}</p></div>' +
                                    '<div class="cb_js_activity_template_container" style="display: none;">' +
                                        '<div class="cb_js_loading cb-loading-block">' +
                                            '{{translations.loadingTranslation}}' +
                                        '</div>' +
                                        '<div class="cb-rows cb_js_no_availability" style="display: none;">' +
                                            '<p>{{translations.noAvailabilityTranslation}}</p>' +
                                        '</div>' +
                                    '</div>' +
                                    '{{#promocodeEnabled}}' +
                                    '<div class="cb-section-promocode-link cb-js-promocode-link-wrapper">' +
                                        '<a href="javascript: void(0);" id="cb-js-open-promocode">{{translations.promocodeLinkTranslation}}</a>' +
                                    '</div>' +
                                    '{{/promocodeEnabled}}' +
                                    '<div class="cb_js_select_product_container">' +
                                    '</div>' +

                                    '<div class="cb-total cb_js_total_price_container" style="display: none;">' +
                                        '<h3>' +
                                            '<span>{{translations.totalPriceTranslation}}:&nbsp;</span>' +
                                            '<span>' +
                                            '<span class="cb-price cb_js_total_price"></span>&nbsp;' +
                                            '<span class="cb-price cb_js_total_price_currency"></span>' +
                                            '</span>' +
                                        '</h3>' +
                                        '<a class="cb-btn cb-icon-right cb_js_book_button">' +
                                            '{{translations.bookTranslation}}' +
                                            '<span class="cb-icon-app cb-icon-arrow-right-alt"></span>' +
                                        '</a>' +
                                    '</div>' +
                                    '{{#promocodeEnabled}}' +

                                    '<div class="cb-section cb-section-params cb-section-promocode cb-js-promocode-section" style="display: none !important;">' +
                                        '<span class="cb-spinner-overlay cb-js-booking-loader" style="display: none;"><span class="cb-spinner"></span></span>' +
                                        '<div class="cb-section-inner">' +
                                            '<div class="cb-reset cb-js-promocode-section-close"></div>' +
                                            '<div class="cb-message cb-message-default">' +
                                                '<h2>{{translations.promocodeWindowTitle}}</h2>' +
                                                '<p>{{translations.promocodeWindowEnterCodeExplantation}}</p>' +
                                                '<p>{{translations.promocodeWindowDiscountExplantation}}</p>' +
                                                '<div class="cb-gui-btn-group cb-gui-btn-group-text-search" id="" style="margin-top: 20px;">' +
                                                    '<label class="cb-gui-text">' +
                                                        '<input class="cb-js-activity-promocode" type="text" placeholder="Enter your code" name="" style="display: inline-block;"/>' +
                                                    '</label>' +
                                                    '<input type="button" value="OK" class="cb-gui-btn cb-js-activity-submit-promocode"/>' +
                                                '</div>' +
                                                '<div class="cb-js-promocode-no-available-dates cb-message-box cb-error" style="display: none;">' +
                                                    '<h4>{{translations.promocodeWindowNoAvailableDatesForPromocode}}</h4>' +
                                                '</div>' +
                                                '<div class="cb-js-promocode-invalid cb-message-box cb-error" style="display: none;">' +
                                                    '<h4>{{translations.promocodeWindowPromocodeInvalid}}</h4>' +
                                                '</div>' +
                                                '<div class="cb-js-promocode-expired cb-message-box cb-error" style="display: none;">' +
                                                    '<h4>{{translations.promocodeWindowPromocodeExpired}}</h4>' +
                                                '</div>' +
                                            '</div>' +
                                        '</div>' +
                                    '</div>' +

                                    '{{/promocodeEnabled}}' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>';
                    var activityAlternativesTemplate = '<div class="cb_js_loading cb-loading-block" style="display: none;"><span></span></div>' +
                '{{#products}}' +
                    '<h3>' +
                    '{{#BookSettings.HasStart}}' +
                            '2. {{StartDateTranslation}} {{StartDate}}, ' +
                    '{{/BookSettings.HasStart}}' +
                    '{{#multirowAlternatives}}' +
                    '{{AlternativeDescription}} {{Duration}}' +
                    '{{/multirowAlternatives}}' +
                    '{{#ProductSettings}}' +
                        '{{#HasMaximumUnitsRule}}' +
                            '<a class="cb_js_maximum_units_trigger" href="javascript:void(0);" style="float: right;">' +
                                '<span class="cb-icon-app cb-icon-info cb-circle" style="background: #2f6a9d;"></span>' +
                            '</a>' +
                            '<div class="cb_js_maximum_units_info cb_hover_detail" style="display: none; background: #fff; border: 1px solid #aaaaaa; padding: 12px; z-index: 999;">{{maxNumberOfUnitsTranslation}}</div>' +
                        '{{/HasMaximumUnitsRule}}' +
                    '{{/ProductSettings}}' +
                    '</h3>' +
                    '<div class="cb_js_product cb_js_booking_widget">' +
                        '<div class="cb-tbl cb-tbl-time">' +
                            '<div class="cb-row">' +
                                '{{#multirowAlternatives}}' +
                               '<div class="cb-cell">' +
                                '{{#alternativeText}}' +
                                '<span class="cb-inner"><b>{{alternativeText}}</b></span>' +
                                '{{/alternativeText}}' +
                                '</div>' +
                                '<div class="cb-cell">' +
                                '{{#AlternativeDescription}}' +
                                '<span class="cb-icnlbl cb-icnlbl-time"><b>{{AlternativeDescription}}</b> <span class="cb-nowrap">{{Duration}}</span></span>' +
                                '{{/AlternativeDescription}}' +
                                '</div>' +
                                    /*'<div class="cb-cell">' +
                                        '<span>' +
                                            '{{alternativeText}}' +
                                        '</span>' +
                                    '</div>' +
                                    '<div class="cb-cell">' +
                                        '<span class="cb-icnlbl cb-icnlbl-time"><b></b></span>' +
                                    '</div>' +*/
                                '{{/multirowAlternatives}}' +
                                '{{#showDropdownAlternatives?}}' +
                                    '<div class="cb-cell">' +
                                        '<span>' +
                                            '{{chooseAlternativeText}}' +
                                        '</span>' +
                                    '</div>' +
                                    '<div class="cb-cell">' +
                                        '<select data-cbisproductid="{{cbisProductId}}" data-productkey="{{productKey}}" class="cb-form-select cb_js_select_alternative">' +
                                            '{{#showSelectAlternativeOption?}}<option value="-1"></option>{{/showSelectAlternativeOption?}}' +
                                            '{{#dropdownAlternatives}}' +
                                                '<option value="{{alternativeKey}}">{{AlternativeDescription}} {{Duration}}</option>' +
                                            '{{/dropdownAlternatives}}' +
                                        '</select>' +
                                    '</div>' +
                                '{{/showDropdownAlternatives?}}' +
                            '</div>' +
                        '</div>' + '{{BookingMessage}}' +
                        '<div class="cb-tbl cb-tbl-config cb_js_alternative_pricegroup_{{productKey}}">' +
                            '<div class="cb-cell-pricegroup"><span class="cb-inner"></span></div>' +
                            '<div class="cb-cell-pricing"><span class="cb-inner"></span></div>' +
                            '<div class="cb-cell-quantity"><span class="cb-inner"></span></div>' +
                        '</div>' +
                    '</div>' +
                '{{/products}}'

                    /*'<td class="cb-cell-product">' +
                        '<div class="cb-inner cb_clr">' +
                            '<div class="cb-cnt-smalldescr">' +
                                '{{#ImageUrl}}' + 
                                    '<div class="cb-column cb-column-photo">' +
                                        '<span class="cb-image-thumb"><img src="{{ImageUrl}}" /></span>' +
                                    '</div>' + 
                                '{{/ImageUrl}}' + 
                                '<div class="cb-column cb-js-activity-product-alternative">' +
                                    '<a class="cb-iconlnk cb_js_activity_detail_link" href="javascript:void(0);">' +
                                        '<span class="cb-bullet"><span class="cb-icon-tiny-info"></span></span>' +
                                        '{{Name}}' + ''
                                        '</a><br/>' +
                                        '{{#BookSettings.HasStart}}' +
                                        '<i>{{StartDateTranslation}}: {{StartDate}}</i>' +
                                        '{{/BookSettings.HasStart}}' +
                                    '<p class="cb-hidden">{{{ShortDescriptionWithFallBack}}}</p>' +
                                    '<div class="cb_js_inline_content" id="cb_inline_content_{{productKey}}" style="display:none; padding: 10px;">'+ 
                                        '<div class="cb-page-title cb-clr">' + 
                                            '<h1 class="cb-title-small">{{Name}}</h1>' +
                                        '</div>' +
                                        '<div class="cb-product-description">' +
                                            '<div class="cb-product-inner">' +
                                                '<div class="cb-column cb-column-photo"><div class="cb-image" style="background-image: url({{BigImageUrl}})"><img src="{{BigImageUrl}}" alt="{{AltText}}"/></div></div>' +
                                                '<div class="cb-column"><p>{{{ShortDescription}}}</p><p>{{{Description}}}</p></div>' +
                                            '</div>' +
                                        '</div>' + 
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</td>' +*/;
                    var alternativePriceGroupTemplate = '{{#priceGroups}}' +
                    '{{#priceGroup?}}' +
                        '<div class="cb-row">' +
                            '<div class="cb-cell">' +
                                '<span>' +
                                    '{{Name}}' +
                                '</span>' +
                            '</div>' +
                            '<div class="cb-cell">' +
                                '<h3 class="cb-price">' +
                                    '{{Price}} {{Currency}}' +
                                '</h3>' +
                            '</div>' +
                            '<div class="cb-cell">' +
                                '<select data-cbisproductid="{{cbisProductId}}" data-productkey="{{productKey}}" data-bookkey="{{BookKey}}" data-price="{{Price}}" class="cb-form-select cb_js_select_pricegroup">' +
                                    '<option value="0">{{noneText}}</option>' +
                                    '{{#quantities}}' +
                                        '<option value="{{quantity}}">×{{quantity}} ({{amount}} {{Currency}})</option>' +
                                    '{{/quantities}}' +
                                '</select>' +
                            '</div>' +
                        '</div>' +
                    '{{/priceGroup?}}' +
                '{{/priceGroups}}';

                    var options = {
                        refCurrency: '',
                        bookingSettingsUrl: 'http://online3-next.citybreak.com/537027515/zh/activitywidget/bookingsettings',
                        promocodeEnabled: false,
                        templates: {
                            activityWidgetTemplate: activityWidgetTemplate,
                            activityGroupWidgetTemplate: activityGroupWidgetTemplate,
                            activityAlternativesTemplate: activityAlternativesTemplate,
                            alternativePriceGroupTemplate: alternativePriceGroupTemplate,
                            activityGroupAlternativesTemplate: activityGroupAlternativesTemplate,
                            alternativePriceGroupTemplate: alternativePriceGroupTemplate,
                            alternativeBookingMessageTemplate: alternativeBookingMessageTemplate
                        },
                        numberOfPriceDecimals: '2',
                        isPreRendered: false
                    };

                    window.citybreakActivityBooking.init(options);


                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_activity_booking_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_activity_booking_widget, executing');

            var target = citybreakjq('#citybreak_activity_booking_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_activity_booking_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_activity_booking_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_activity_booking_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_activity_booking_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_activity_searchform_widget', function () {
            console.log('onContentReady #citybreak_activity_searchform_widget, executing');

            var target = document.getElementById('citybreak_activity_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_activity_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_activity_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_activity_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine\">\r\n        <div class=\"Citybreak_SidebarBox Citybreak_Search cb_activity_searchbox\">\r\n            <div class=\"cb_inner\">\r\n                <div class=\"cb_ex\"></div>\r\n                <div class=\"cb_hd\">\r\n                    <h4>搜索与预订</h4>\r\n                    <span class=\"cb_ex_label\" title=\"做\">做</span>\r\n                </div>\r\n                <div class=\"cb_bd\">\r\n                    <form action=\"http://online3-next.citybreak.com/537027515/zh/todosearch/search?redirto=Index\" method=\"post\" id=\"cb_act_bookingform\" >\t\r\n                        <div class=\"cb_copy cb_clr\">\r\n                            <div class=\"Citybreak_SearchBox\">\r\n\t\t\t\t\t\t\r\n                                <div class=\"cb_form_row cb_ev_section_datepicker\">\r\n                                    <div class=\"cb_col_left_w2 cb_selects_w4\">\r\n                                        <label class=\"cb_titlelabel\">从:</label>\r\n                                        <div class=\"cb_date_input\">\r\n                                            <label>\r\n                                                <span class=\"cb_act_datefrom_label\" style=\"display: none;\">\r\n                                                    <span class=\"cb_act_datefrom_day\"></span>\r\n                                                    <span class=\"cb_act_datefrom_month\"></span>\r\n                                                    <span class=\"cb_act_datefrom_year\"></span>\r\n                                                </span> \r\n                                                <input type=\"text\" id=\"cb_act_form_datefrom\" name=\"start\" class=\"cb_validate_startdate cb_validate_required\" value=\"2019-06-18\"/>\r\n                                            </label>\r\n                                            <a class=\"cp_cal_trig_from\" id=\"cb_act_trigger_from\"></a>\r\n                                        </div>\r\n                                    </div>\r\n                                </div>\r\n\r\n                                <div class=\"cb_form_row cb_ev_section_lenght\">\r\n                                        <div class=\"cb_radio\">\r\n                                            <label>\r\n                                                <input type=\"radio\" name=\"period\" value=\"Forward\" checked='checked' />\r\n                                                <span class=\"cb_radio_lbl\">及之后数日</span>\r\n                                            </label>\r\n                                        </div>\r\n                                    <div class=\"cb_radio\">\r\n                                        <label>\r\n                                            <input type=\"radio\" name=\"period\" value=\"OneDay\"  />\r\n                                            <span class=\"cb_radio_lbl\">仅选定日期</span>\r\n                                        </label>\r\n                                    </div>\r\n                                        <div class=\"cb_radio\">\r\n                                            <label>\r\n                                                <input type=\"radio\" name=\"period\" value=\"OneWeek\"  />\r\n                                                <span class=\"cb_radio_lbl\">一周</span>\r\n                                            </label>\r\n                                        </div>\r\n\r\n                                    <div class=\"cb_radio\">\r\n                                        <label>\r\n                                            <input type=\"radio\" name=\"period\" value=\"ToDate\"  />\r\n                                            <span class=\"cb_radio_lbl\">直至</span>\r\n                                        </label>\r\n                                    </div>\r\n                                </div>\r\n                                <div class=\"cb_form_row\" id=\"cb_act_dateto_container\" style=\"display:none;\">\r\n                                    <div class=\"cb_col_left_w2 cb_selects_w4\">\r\n                                        <label class=\"cb_titlelabel\">至:</label>\r\n                                        <div class=\"cb_date_input\">\r\n                                            <label>\r\n                                                <span class=\"cb_act_dateto_label\" style=\"display: none;\">\r\n                                                    <span class=\"cb_act_dateto_day\"></span>\r\n                                                    <span class=\"cb_act_dateto_month\"></span>\r\n                                                    <span class=\"cb_act_dateto_year\"></span>\r\n                                                </span> \r\n                                                <input type=\"text\" id=\"cb_act_form_dateto\" class=\"cb_validate_enddate\" name=\"end\"/>\r\n                                            </label>\r\n                                            <a class=\"cp_cal_trig_from\" id=\"cb_act_trigger_to\"></a>\r\n                                        </div>\r\n                                    </div>\r\n                                </div>\r\n\t\t\t\t\t\t\t\r\n                            </div>\r\n                        </div>\r\n\r\n                        <div class=\"cb_btn cb_clr\" id=\"cb_act_srch_btn1\">\r\n                            <input type=\"submit\" class=\"Citybreak_Button cb_searchbutton\" id=\"cb_act_SearchButton\" value=\"搜索\" />\r\n                        </div>\r\n\r\n                        <input type=\"hidden\" name=\"cb_geoId\" />\r\n\r\n                    </form>\r\n\r\n                    <div id=\"cb_act_bookingdetails\"  style=\"display: none;\">\r\n                            <div class=\"cb_search_summary\">\r\n                                <div class=\"cb_copy\">\r\n                                    <ul>\r\n                                        <li>\r\n                                            <span class=\"cb_lbl\">Search from:</span>\r\n                                            周二 18 6月 2019\r\n                                        </li>\r\n                                        <li>\r\n                                            <span class=\"cb_lbl\">Search:</span>\r\n                                            及之后数日\r\n                                        </li>\r\n                                    </ul>\r\n                                </div>\r\n                            </div>\r\n                            <div class=\"cb_btn cb_clr\">\r\n                                <a href=\"javascript:;\" class=\"Citybreak_change_link\" id=\"cb_act_changebooking\">\r\n                                    <span class=\"cb_icon cb_expandicon\"></span>Change search\r\n                                </a>\r\n                            </div>\r\n                        </div>\r\n                </div>\r\n                <div class=\"cb_ft\"></div>\r\n            </div>\r\n        </div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_activity_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_activity_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {


                    var initStartDate = new Date(2019, 5, 18, 0, 0, 0, 0);

                    var initEndDate = new Date(2019, 6, 18, 0, 0, 0, 0);


                    var minStartDate = new Date(2019, 5, 18, 0, 0, 0, 0);

                    var validationMessages = {
                        start: 'Invalid date',
                        end: 'Invalid date',
                        CookieAlert: 'Warning! Cookies are disabled. '
                    };

                    var filterState = 'd=20190618';

                    citybreakActivitySearchForm.initSearchForm(
                        initStartDate,
                        initEndDate,
                        minStartDate,
                        validationMessages,
                        filterState
                    );

                    $('#cb_act_SearchButton').click(function (e) {
                        e.preventDefault();
                        if ($("#cb_act_form_datefrom").val().length > 0) {
                            citybreakActivitySearchForm.post('http://online3-next.citybreak.com/537027515/zh/todosearch/search?redirto=Index');
                        }
                    });

                    $('#cb_act_SearchButton').one_time_action({ reactivate: 5000 });


                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_activity_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_activity_searchform_widget, executing');

            var target = citybreakjq('#citybreak_activity_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_activity_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_activity_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_activity_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_activity_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_basket_compactbasket_widget', function () {
            console.log('onContentReady #citybreak_basket_compactbasket_widget, executing');

            var target = document.getElementById('citybreak_basket_compactbasket_widget');

            if (!target) {
                console.log('onContentReady #citybreak_basket_compactbasket_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_basket_compactbasket_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_basket_compactbasket_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_Widget Citybreak_CompactBasket\">\r\n\t<div class=\"cb_inner\">\r\n\t\t<div class=\"cb_ex\"></div>\r\n\t\t<div class=\"cb_hd cb_js_showhide\">\r\n\t\t    <h4>\r\n\t\t        <span class=\"cb_nr_products\" id=\"cb_compact_nr_products\" style=\"display: none\"></span>\r\n\t\t        <span class=\"cb_lbl\">我的篮球</span>\r\n\t\t        <span class=\"cb_price\" id=\"cb_compact_basket_price\"><span class=\"cb_loading\"></span></span>\r\n\t\t        <span class=\"cb_expander\" style=\"display: none\">\r\n\t\t\t        <span class=\"cb_icon cb_expandicon\" title=\"显示/隐藏\"></span>\r\n\t\t\t        <span class=\"cb_txt\">显示/隐藏</span>\r\n\t\t\t    </span>\r\n\t\t    </h4>\r\n\t\t</div>\r\n\t\t<div class=\"cb_bd\">\r\n\t\t\t<div class=\"cb_summary_list\">\t\r\n\t\t\t\t<div id=\"cb_compact_basket_product_list\"></div>\t\t\r\n\t\t\t</div>\r\n\t\t\t\r\n\t\t\t<div id=\"cb_compact_basket_total_amount\"></div>\r\n\t\t\t\r\n            \r\n\t\t\t\r\n\r\n\t\t</div>\r\n\t\t<div class=\"cb_ft\"></div>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_basket_compactbasket_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_basket_compactbasket_widget, executing inline widget scripts');





                (function ($, undefined) {

                    var alreadyHasQueryString = false;
                    var callBackString = alreadyHasQueryString ? '&' + 'callback=?' : '?callback=?';

                    citybreakjq.getJSON('http://online3-next.citybreak.com/537027515/zh/basketwidget/compactbasketstatus' + callBackString, function (result) {
                        if (result) {
                            citybreakjq('#cb_compact_nr_products').html(result.NrProductsHtml);
                            citybreakjq('#cb_compact_basket_price').html(result.PriceHtml);
                            citybreakjq('#cb_compact_basket_product_list').html(result.ProductListHtml);
                            citybreakjq('#cb_compact_basket_total_amount').html(result.TotalAmountHtml);
                        }
                    });

                    var options = {
                        animation: 2,
                        url: "http://online3-next.citybreak.com/537027515/zh/basketwidget/compactbasketstatus",
                        callback: callBackString
                    };

                    window.citybreakCompactBasket.init(options);


                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_basket_compactbasket_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_basket_compactbasket_widget, executing');

            var target = citybreakjq('#citybreak_basket_compactbasket_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_basket_compactbasket_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_basket_compactbasket_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_basket_compactbasket_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_basket_compactbasket_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_basket_minibasket_widget', function () {
            console.log('onContentReady #citybreak_basket_minibasket_widget, executing');

            var target = document.getElementById('citybreak_basket_minibasket_widget');

            if (!target) {
                console.log('onContentReady #citybreak_basket_minibasket_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_basket_minibasket_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_basket_minibasket_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_SidebarBox Citybreak_BookingSummary\">\r\n\t<div class=\"cb_inner\">\r\n\t\t<div class=\"cb_ex\"></div>\r\n\t\t<div class=\"cb_hd\"><h4>我的篮球</h4></div>\r\n\t\t<div class=\"cb_bd\">\r\n\t\t\t<div class=\"cb_summary_list\">\r\n\t\t\t    <div id=\"cb_mini_basket_product_list\"></div>\r\n\t\t\t</div>\r\n\r\n\t\t\t<div id=\"cb_mini_basket_total_amount\"></div>\r\n\t\t</div>\r\n\t\t<div class=\"cb_ft\"></div>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_basket_minibasket_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_basket_minibasket_widget, executing inline widget scripts');





                (function ($, undefined) {

                    var alreadyHasQueryString = false;
                    var callBackString = alreadyHasQueryString ? '&' + 'callback=?' : '?callback=?';
                    citybreakjq.getJSON('http://online3-next.citybreak.com/537027515/zh/basketwidget/minibasketstatus' + callBackString, function (result) {
                        if (result) {
                            citybreakjq('#cb_mini_basket_product_list').html(result.ProductListHtml);
                            citybreakjq('#cb_mini_basket_total_amount').html(result.TotalAmountHtml);
                        }
                    });


                    citybreakjq('.cb_summary_list .cb_category_title .cb_expander').click(function (e) {
                        e.preventDefault();
                        citybreakjq(this).parent().parent().parent().next().toggle();
                        if (citybreakjq(this).find('span.cb_icon').hasClass('cb_expandicon')) {
                            citybreakjq(this).find('span.cb_txt').html('<%= lm("MiniBasket.ProductGroup.Products.HideDetails")%>');
                            citybreakjq(this).find('span.cb_icon').removeClass('cb_expandicon');
                            citybreakjq(this).find('span.cb_icon:not(span.cb_icon.cb_shareicon, span.cb_icon.cb_shareemail, span.cb_icon.cb_sharecalendar, span.cb_icon.cb_shareprint)').addClass('cb_collapseicon');
                            if (citybreakjq(this).parent().parent().parent().parent().hasClass('cb_sel')) {
                                citybreakjq(this).parent().parent().parent().parent().removeClass('cb_sel');
                            } else {
                                citybreakjq(this).parent().parent().parent().parent().addClass('cb_sel');
                            }
                            return true;
                        }
                        if (citybreakjq(this).find('span.cb_icon').hasClass('cb_collapseicon')) {
                            citybreakjq(this).find('span.cb_txt').html('<%= lm("MiniBasket.ProductGroup.Products.Details")%>');
                            citybreakjq(this).find('span.cb_icon').removeClass('cb_collapseicon');
                            citybreakjq(this).find('span.cb_icon:not(span.cb_icon.cb_shareicon, span.cb_icon.cb_shareemail, span.cb_icon.cb_sharecalendar, span.cb_icon.cb_shareprint)').addClass('cb_expandicon');
                            if (citybreakjq(this).parent().parent().parent().parent().hasClass('cb_sel')) {
                                citybreakjq(this).parent().parent().parent().parent().removeClass('cb_sel');
                            } else {
                                citybreakjq(this).parent().parent().parent().parent().addClass('cb_sel');
                            }
                            return true;
                        }
                        return false;
                    });


                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_basket_minibasket_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_basket_minibasket_widget, executing');

            var target = citybreakjq('#citybreak_basket_minibasket_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_basket_minibasket_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_basket_minibasket_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_basket_minibasket_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_basket_minibasket_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_carrental_searchform_widget', function () {
            console.log('onContentReady #citybreak_carrental_searchform_widget, executing');

            var target = document.getElementById('citybreak_carrental_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_carrental_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_carrental_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_carrental_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine\">\r\n\t<div class=\"Citybreak_SidebarBox Citybreak_Search cb_carrental_searchbox\">\r\n\t<form action=\"http://online3-next.citybreak.com/537027515/zh/carrentalsearch/search\" method=\"post\" name=\"cb_ns_acc_search\">\r\n\t<input id=\"cb_pickUpCode\" type=\"hidden\" value=\"\" name=\"cb_pickUpCode\" />\r\n\t<input id=\"cb_pickUpLocationNameId\" type=\"hidden\" value=\"\" name=\"cb_pickUpLocationNameId\" />\r\n\t<input id=\"cb_carrental_startSelection\" type=\"hidden\" value=\"\" />\r\n\r\n\t<input id=\"cb_dropOffCode\" type=\"hidden\" value=\"\" name=\"cb_dropOffCode\" />\r\n\t<input id=\"cb_dropOffLocationNameId\" type=\"hidden\" value=\"\" name=\"cb_dropOffLocationNameId\" />\r\n\t<input id=\"cb_carrental_endSelection\" type=\"hidden\" value=\"\" />\r\n\r\n\r\n\t\t<div class=\"cb_inner\">\r\n\t\t\t<div class=\"cb_ex\">\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_hd\">\r\n\t\t\t\t<h4>搜寻酒店</h4>\r\n\t\t\t\t<span class=\"cb_ex_label\" title=\"汽车出租\">租车</span>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_bd\">\r\n\t\t\t\r\n\t\t\t\t<div id=\"Citybreak_carrental_bookingform\" class=\"\">\r\n\t\t\t\t\t<div class=\"cb_copy cb_clr\">\r\n\t\t\t\t\t\t<div class=\"Citybreak_SearchBox\">\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ac_section_keyword\" id=\"cb_ac_carrental_pickup_searchfield_cnt\" >\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_main_formlabel\">取车城市或机场:</label>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_keyword_input\"><label><input title=\"取车城市或机场\" type=\"text\" name=\"cb_ns_pickupspot\" id=\"cb_ac_carrental_pickup_searchfield\" value=\"\"/></label></div>\r\n\t\t\t\t\t\t\t\t</div>\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div id=\"cbnoresult_srch\" class=\"cb_noresults_msg\"></div>\t\t\t\t\t\t\t   \r\n\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row cb_2col cb_ac_section_dates\" id=\"cb_form_carrental_pickUpHour_cnt\" >\r\n\r\n\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">取车日期:</label>\r\n\t\t\t\t\t\t\t\t<div class=\"cb_col_left\">\r\n\t\t\t\t\t\t\t\t    <div class=\"cb_date_input\">\r\n\t\t\t\t\t\t\t\t        <label>\r\n\t\t\t\t\t\t\t\t            <input title=\"取车日期\" type=\"text\" name=\"startdate\" id=\"CB_form_carrental_datefrom\" />\r\n\t\t\t\t\t\t\t\t        </label>\r\n                                        <a class=\"cp_cal_trig_from\" id=\"Citybreak_trigger_from_carrental\" title=\"取车日期\"></a>\r\n\t\t\t\t\t\t\t\t    </div>\r\n\t\t\t\t\t\t\t\t\t<span class=\"cb_byline\" id=\"CB_form_carrental_datefrom_byline\"></span>\r\n\t\t\t\t\t\t\t\t</div>\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\t<div class=\"cb_col_right\">\r\n\t\t\t\t\t\t\t\t\t<select name=\"starthour\" id=\"cb_form_carrental_pickUpHour\" title=\"接机时间\">\r\n\t\t\t\t\t\t\t\t\t    <option value=\"\" >\r\n\t\t\t\t\t\t\t\t\t        选择\r\n\t\t\t\t\t\t\t\t\t    </option>\r\n\r\n\t\t\t                                <option value=\"30\" >\r\n\t\t\t                                    0:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"60\" >\r\n\t\t\t                                    1:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"90\" >\r\n\t\t\t                                    1:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"120\" >\r\n\t\t\t                                    2:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"150\" >\r\n\t\t\t                                    2:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"180\" >\r\n\t\t\t                                    3:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"210\" >\r\n\t\t\t                                    3:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"240\" >\r\n\t\t\t                                    4:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"270\" >\r\n\t\t\t                                    4:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"300\" >\r\n\t\t\t                                    5:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"330\" >\r\n\t\t\t                                    5:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"360\" >\r\n\t\t\t                                    6:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"390\" >\r\n\t\t\t                                    6:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"420\" >\r\n\t\t\t                                    7:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"450\" >\r\n\t\t\t                                    7:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"480\" >\r\n\t\t\t                                    8:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"510\" >\r\n\t\t\t                                    8:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"540\" >\r\n\t\t\t                                    9:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"570\" >\r\n\t\t\t                                    9:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"600\" >\r\n\t\t\t                                    10:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"630\" >\r\n\t\t\t                                    10:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"660\" >\r\n\t\t\t                                    11:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"690\" >\r\n\t\t\t                                    11:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"720\" selected=&quot;selected&quot;>\r\n\t\t\t                                    12:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"750\" >\r\n\t\t\t                                    12:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"780\" >\r\n\t\t\t                                    13:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"810\" >\r\n\t\t\t                                    13:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"840\" >\r\n\t\t\t                                    14:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"870\" >\r\n\t\t\t                                    14:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"900\" >\r\n\t\t\t                                    15:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"930\" >\r\n\t\t\t                                    15:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"960\" >\r\n\t\t\t                                    16:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"990\" >\r\n\t\t\t                                    16:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1020\" >\r\n\t\t\t                                    17:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1050\" >\r\n\t\t\t                                    17:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1080\" >\r\n\t\t\t                                    18:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1110\" >\r\n\t\t\t                                    18:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1140\" >\r\n\t\t\t                                    19:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1170\" >\r\n\t\t\t                                    19:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1200\" >\r\n\t\t\t                                    20:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1230\" >\r\n\t\t\t                                    20:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1260\" >\r\n\t\t\t                                    21:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1290\" >\r\n\t\t\t                                    21:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1320\" >\r\n\t\t\t                                    22:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1350\" >\r\n\t\t\t                                    22:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1380\" >\r\n\t\t\t                                    23:00 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"1410\" >\r\n\t\t\t                                    23:30 \r\n\t\t\t                                </option>\r\n\t\t\t                                <option value=\"0\" >\r\n\t\t\t                                    0:00 \r\n\t\t\t                                </option>\r\n\t\t\t\t\t\t\t\t\t</select>\r\n\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ac_section_nodates\">\r\n\t\t\t\t\t\t\t\t<div class=\"cb_checkbox\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t<input title=\"我回到租的车在不同的位置\" type=\"checkbox\" name=\"cb_ns_differentDropOff\" id=\"cb_ac_carrental_differentDropOff\"  />\r\n\t\t\t\t\t\t\t\t\t<span class=\"cb_checkbox_lbl cb_txt_italic\">我回到租的车在不同的位置</span></label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ac_section_keyword\" id=\"cb_ac_section_dropoff\" >\r\n\t\t\t\t\t\t\t\t<label class=\"cb_main_formlabel\">下车:</label>\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_keyword_input\">\r\n\t\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">投递地点:</label>\r\n\t\t\t\t\t\t\t\t\t\t<input title=\"投递地点\" name=\"cb_ns_dropoffspot\" type=\"text\" id=\"cb_ac_carrental_dropOff_searchfield\" value=\"\" />\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t<div id=\"cb_ac_carrental_cbnoresult_srch\" class=\"cb_noresults_msg\"></div>\t\r\n\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row cb_2col cb_ac_section_dates\" id=\"cb_form_carrental_dropOffHour_cnt\" >\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">下车日期:</label>\r\n\t\t\t\t\t\t\t\t<div class=\"cb_col_left\">\r\n\t\t\t\t\t\t\t\t    <div class=\"cb_date_input\">\r\n\t\t\t\t\t\t\t\t        <label>\r\n\t\t\t\t\t\t\t\t            <input name=\"enddate\" title=\"下车日期\" type=\"text\" id=\"CB_form_carrental_dateto\" />\r\n\t\t\t\t\t\t\t\t        </label>\r\n                                        <a class=\"cp_cal_trig_from\" id=\"Citybreak_trigger_to_carrental\" title=\"下车日期\"></a>\r\n\t\t\t\t\t\t\t\t    </div>\t\r\n\t\t\t\t\t\t\t\t\t<span class=\"cb_byline\" id=\"CB_form_carrental_dateto_byline\"></span>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_col_right\">\r\n\t\t\t\t\t\t\t\t\t<select name=\"endhour\" id=\"cb_form_carrental_dropOffHour\" title=\"下车时间\">\r\n\t\t\t\t\t\t\t\t\t\t<option value=\"\" >选择</option>\r\n                                            <option value=\"30\" >\r\n                                                0:30\r\n                                            </option>\r\n                                            <option value=\"60\" >\r\n                                                1:00\r\n                                            </option>\r\n                                            <option value=\"90\" >\r\n                                                1:30\r\n                                            </option>\r\n                                            <option value=\"120\" >\r\n                                                2:00\r\n                                            </option>\r\n                                            <option value=\"150\" >\r\n                                                2:30\r\n                                            </option>\r\n                                            <option value=\"180\" >\r\n                                                3:00\r\n                                            </option>\r\n                                            <option value=\"210\" >\r\n                                                3:30\r\n                                            </option>\r\n                                            <option value=\"240\" >\r\n                                                4:00\r\n                                            </option>\r\n                                            <option value=\"270\" >\r\n                                                4:30\r\n                                            </option>\r\n                                            <option value=\"300\" >\r\n                                                5:00\r\n                                            </option>\r\n                                            <option value=\"330\" >\r\n                                                5:30\r\n                                            </option>\r\n                                            <option value=\"360\" >\r\n                                                6:00\r\n                                            </option>\r\n                                            <option value=\"390\" >\r\n                                                6:30\r\n                                            </option>\r\n                                            <option value=\"420\" >\r\n                                                7:00\r\n                                            </option>\r\n                                            <option value=\"450\" >\r\n                                                7:30\r\n                                            </option>\r\n                                            <option value=\"480\" >\r\n                                                8:00\r\n                                            </option>\r\n                                            <option value=\"510\" >\r\n                                                8:30\r\n                                            </option>\r\n                                            <option value=\"540\" >\r\n                                                9:00\r\n                                            </option>\r\n                                            <option value=\"570\" >\r\n                                                9:30\r\n                                            </option>\r\n                                            <option value=\"600\" >\r\n                                                10:00\r\n                                            </option>\r\n                                            <option value=\"630\" >\r\n                                                10:30\r\n                                            </option>\r\n                                            <option value=\"660\" >\r\n                                                11:00\r\n                                            </option>\r\n                                            <option value=\"690\" >\r\n                                                11:30\r\n                                            </option>\r\n                                            <option value=\"720\" selected=&quot;selected&quot;>\r\n                                                12:00\r\n                                            </option>\r\n                                            <option value=\"750\" >\r\n                                                12:30\r\n                                            </option>\r\n                                            <option value=\"780\" >\r\n                                                13:00\r\n                                            </option>\r\n                                            <option value=\"810\" >\r\n                                                13:30\r\n                                            </option>\r\n                                            <option value=\"840\" >\r\n                                                14:00\r\n                                            </option>\r\n                                            <option value=\"870\" >\r\n                                                14:30\r\n                                            </option>\r\n                                            <option value=\"900\" >\r\n                                                15:00\r\n                                            </option>\r\n                                            <option value=\"930\" >\r\n                                                15:30\r\n                                            </option>\r\n                                            <option value=\"960\" >\r\n                                                16:00\r\n                                            </option>\r\n                                            <option value=\"990\" >\r\n                                                16:30\r\n                                            </option>\r\n                                            <option value=\"1020\" >\r\n                                                17:00\r\n                                            </option>\r\n                                            <option value=\"1050\" >\r\n                                                17:30\r\n                                            </option>\r\n                                            <option value=\"1080\" >\r\n                                                18:00\r\n                                            </option>\r\n                                            <option value=\"1110\" >\r\n                                                18:30\r\n                                            </option>\r\n                                            <option value=\"1140\" >\r\n                                                19:00\r\n                                            </option>\r\n                                            <option value=\"1170\" >\r\n                                                19:30\r\n                                            </option>\r\n                                            <option value=\"1200\" >\r\n                                                20:00\r\n                                            </option>\r\n                                            <option value=\"1230\" >\r\n                                                20:30\r\n                                            </option>\r\n                                            <option value=\"1260\" >\r\n                                                21:00\r\n                                            </option>\r\n                                            <option value=\"1290\" >\r\n                                                21:30\r\n                                            </option>\r\n                                            <option value=\"1320\" >\r\n                                                22:00\r\n                                            </option>\r\n                                            <option value=\"1350\" >\r\n                                                22:30\r\n                                            </option>\r\n                                            <option value=\"1380\" >\r\n                                                23:00\r\n                                            </option>\r\n                                            <option value=\"1410\" >\r\n                                                23:30\r\n                                            </option>\r\n                                            <option value=\"0\" >\r\n                                                0:00\r\n                                            </option>\r\n\t\t\t\t\t\t\t\t\t</select>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n\t\t\t\t\r\n\t\t\t\t\t<div class=\"cb_btn cb_clr\">\r\n\t\t\t\t\t\t<a href=\"#\" class=\"Citybreak_Button cb_searchbutton\" id=\"cb_carrental_searchbutton\" title=\"搜索\">\r\n\t\t\t\t\t\t\t搜索</a>\r\n\t\t\t\t\t\t<input type=\"submit\" value=\"搜索\" id=\"cb_ns_submitbtn\" class=\"cb_ns_submitbtn\" title=\"搜索\" style=\"display: none;\" />\r\n\t\t\t\t\t</div>\r\n\r\n\t\t\t\t</div>\r\n\r\n\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_ft\">\r\n\t\t\t</div>\r\n\t\t</div>\r\n\t</form>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_carrental_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_carrental_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {

                    $("input.Citybreak_Button").one_time_action({ reactivate: 100 });

                    var validationMessages = {};

                    validationMessages.EmptyPickUpLocation = "请选择拾取位置";
                    validationMessages.EmptyDropOffDestination = "请选择投递地点";

                    validationMessages.PleaseChoosePickUpLocation = "请选择拾取位置";
                    validationMessages.PleaseChooseDropOffToDestination = "请选择投递地点";

                    validationMessages.InvalidPickUpDate = "无效取货日期";
                    validationMessages.PickUpDateHasPassed = "取车日期已过";

                    validationMessages.InvalidDropOffDate = "无效的下车日期";
                    validationMessages.DropOffDateHasPassed = "下车日期已过";

                    validationMessages.DropOffDateShouldBeGreaterThanPickUp = "下车时间不能比回升时间早";
                    validationMessages.YouHaveToBookAtleastMinimumBookMinutes = "你必须清洁车至少一小时";

                    validationMessages.SameStartAndEndIATACode = "从去离开，都是一样的";

                    validationMessages.ChoosePickUpHour = "选择收件时间";
                    validationMessages.ChooseDropOffHour = "选择落客时间";

                    validationMessages.Day = "日";
                    validationMessages.Days = "天";
                    validationMessages.CookieAlert = "Warning! Cookies are disabled. ";


                    var carRentalSrchCfg = citybreakCommonSearchForm.getCarRentalSearchConfiguration(
                    new Date(2019, 5, 18, 13, 21, 10, 523),
                    new Date(2019, 5, 18, 13, 21, 10, 523),
                    new Date(2019, 5, 18, 13, 21, 10, 523)
                    );

                    var carRentalSearchUrls = {
                        'getPickUpIataSpots': 'http://online3-next.citybreak.com/537027515/zh/carrental/getpickupiataspots',
                        'getDropOffIataSpots': 'http://online3-next.citybreak.com/537027515/zh/carrental/getdropoffiataspots',
                        'newSearch': 'http://online3-next.citybreak.com/537027515/zh/carrentalsearch/search'
                    };

                    var carRentalSearchLocalizedTexts = {
                        'AutoCompleteNoResults': "没有结果",
                        'AutoCompleteTheresMoreByLine': "选择城市或机场"
                    };

                    var validationSettings = {};
                    validationSettings.RequireLeavingFrom = true;
                    validationSettings.RequireGoingTo = true;

                    citybreakCarRentalSearchForm.initializeCarRentalSearchForm(
                    validationMessages,
                    60,
                    carRentalSrchCfg.pickUpDate,
                    carRentalSrchCfg.dropOffDate,
                    0,
                    carRentalSearchUrls,
                    carRentalSearchLocalizedTexts,
                    true,
                    validationSettings,
                    new Date(2019, 5, 18, 13, 21, 10, 523),
                    0,
                    '地区，地标或机场'
                    );


                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_carrental_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_carrental_searchform_widget, executing');

            var target = citybreakjq('#citybreak_carrental_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_carrental_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_carrental_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_carrental_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_carrental_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_cruise_searchform_widget', function () {
            console.log('onContentReady #citybreak_cruise_searchform_widget, executing');

            var target = document.getElementById('citybreak_cruise_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_cruise_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_cruise_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_cruise_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine\">\r\n\t<div class=\"Citybreak_SidebarBox Citybreak_Search cb_cruise_searchbox\">\r\n\t\t<div class=\"cb_inner\">\r\n\t\t\t<div class=\"cb_ex\"></div>\r\n\t\t\t<div class=\"cb_hd\">\r\n\t\t\t\t<h4>渡口</h4>\r\n\t\t\t\t<span class=\"cb_ex_label\" title=\"沿海巡航\">沿海巡航</span>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_bd\">\r\n\t\t\t\r\n\t\t\t\t<form action=\"http://online3-next.citybreak.com/537027515/zh/cruisesearch/search\" method=\"post\" name=\"cb_ns_ferry_search\">\r\n\t\t\t\r\n\t\t\t\t\t<div id=\"Citybreak_cruise_bookingform\" class=\"\">\r\n\t\t\t\t\r\n\t\t\t\t\t\t<div class=\"cb_copy cb_clr\">\r\n                            <div class=\"Citybreak_SearchBox\">\r\n                                \r\n                                \r\n\r\n<div class=\"cb_form_row cb_2col cb_ac_section_dates\">\r\n    <div class=\"\">\r\n        <label class=\"cb_titlelabel\">你打算什么时候去？</label>\r\n        <div class=\"cb_date_input\">\r\n            <label>\r\n                <input title=\"出发日期\" name=\"cb_cruise_date\" type=\"text\" id=\"cb_cruise_date_date\" value=\"2019/6/19\"/>\r\n            </label>\r\n            <a class=\"cp_cal_trig_from\" id=\"cb_cruise_date_selector\" title=\"出发日期\"></a>\r\n        </div>\r\n        <span class=\"cb_byline\" id=\"cb_cruise_date_byline\"></span>\r\n    </div>\t\t\t\t\t\t\t\t\r\n</div>\r\n\r\n\r\n                                \r\n                                \r\n                                \r\n              \r\n\r\n<div class=\"cb_form_row\" id=\"cb_cruise_package_dropdown\">\r\n    <label class=\"cb_titlelabel\">邮轮航线:</label>\r\n    <div class=\"cb_selects cb_selects_wide\">\r\n        <select id=\"cb_cruise_package_select\" name=\"cb_cruise_package\"  title=\"出港\">\r\n            <option value=\"\" >请选择一个路径</option>\r\n        </select>\r\n    </div>\r\n</div>\r\n\r\n\r\n                                \r\n                                <input type=\"hidden\" name=\"cb_cruise_cabins\" value=\"1\" />\r\n                                \r\n                                \r\n      <div id=\"roomConfigurations_passengerselector0\">\r\n        <input type=\"hidden\" id=\"cb_cruise_passengerstring_0\" value=\"\" name=\"roomConfigurations\" />\t\r\n        <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\t\t\t\t\t\t\t\r\n\t\t\t<div class=\"cb_col_left\">\r\n\t\t\t\t<label class=\"cb_titlelabel\">乘客</label>\r\n\t\t\t\t<select id=\"cb_cruise_numAdults_0\" title=\"成人\">\r\n\t\t\t\t\t<option value=\"1\" >\r\n\t\t\t\t\t\t1 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"2\" selected='selected'>\r\n\t\t\t\t\t\t2 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"3\" >\r\n\t\t\t\t\t\t3 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"4\" >\r\n\t\t\t\t\t\t4 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"5\" >\r\n\t\t\t\t\t\t5 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"6\" >\r\n\t\t\t\t\t\t6 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"7\" >\r\n\t\t\t\t\t\t7 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"8\" >\r\n\t\t\t\t\t\t8 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"9\" >\r\n\t\t\t\t\t\t9 成人\r\n\t\t\t\t\t</option>\r\n\t\t\t\t</select>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_col_right\">\r\n\t\t\t\t<label class=\"cb_titlelabel\">&nbsp;</label>\r\n\t\t\t\t<select id=\"cb_cruise_numChild_0\" title=\"孩子\">\r\n\t\t\t\t\t<option value=\"0\" selected='selected'>\r\n\t\t\t\t\t\t0 孩子\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"1\" >\r\n\t\t\t\t\t\t1 孩子\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"2\" >\r\n\t\t\t\t\t\t2 孩子\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"3\" >\r\n\t\t\t\t\t\t3 孩子\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"4\" >\r\n\t\t\t\t\t\t4 孩子\r\n\t\t\t\t\t</option>\r\n\t\t\t\t\t<option value=\"5\" >\r\n\t\t\t\t\t\t5 孩子\r\n\t\t\t\t\t</option>\r\n\t\t\t\t</select>\r\n\t\t\t</div>\r\n\t\t</div>\r\n\t\t<div class=\"cb_form_row cb_hidden cb_ac_section_room_childages\" id=\"cb_cruise_childage_cont_0\" >\r\n\t\t\t<div class=\"cb_fields cb_children cb_hidden\">\r\n\t\t\t\t<label class=\"cb_titlelabel\">\r\n\t\t\t\t\t儿童的年龄 (0-17)\r\n\t\t\t\t</label>\r\n\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show1 cb_hidden\">\r\n\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t1:</span><label for=\"cb_cruise_childage_01\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_cruise_childage_01\" name=\"cb_cruise_childage_01\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show2 cb_hidden\">\r\n\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t2:</span><label for=\"cb_cruise_childage_02\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_cruise_childage_02\" name=\"cb_cruise_childage_02\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show3 cb_hidden\">\r\n\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t3:</span><label for=\"cb_cruise_childage_03\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_cruise_childage_03\" name=\"cb_cruise_childage_03\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show4 cb_hidden\">\r\n\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t4:</span><label for=\"cb_cruise_childage_04\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_cruise_childage_04\" name=\"cb_cruise_childage_04\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show5 cb_hidden\">\r\n\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t5:</span><label for=\"cb_cruise_childage_05\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_cruise_childage_05\" name=\"cb_cruise_childage_05\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t</div>\r\n\t\t</div>\r\n\t</div>\t\t\t\t\t\r\n\r\n\r\n\r\n\r\n                            </div>\r\n\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t<div class=\"cb_btn cb_clr\">\r\n\t\t\t\t\t\t\t<a href=\"#\" class=\"Citybreak_Button cb_searchbutton\" id=\"cb_cruise_searchbutton\" title=\"搜索\">搜索</a>\r\n\t\t\t\t\t\t\t<input type=\"submit\" value=\"搜索\" id=\"cb_ns_ferry_submitbtn\" class=\"cb_ns_submitbtn\" title=\"搜索\" />\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</form>\r\n\r\n\t\t   \r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_ft\"></div>\r\n\t\t</div>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_cruise_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_cruise_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {



                    var dateElement = $('#cb_cruise_date_date');
                    var triggerElement = $('#cb_cruise_date_selector');
                    var dayofWeekElement = $('#cb_cruise_date_byline');

                    $.subscribe("/single-datepicker/cb_cruise_date_selector/invalid-date/", function () {
                        dateElement.attr('title', citybreak.htmlDecode('Invalid date'));
                        dateElement.tipsy("show");
                    });

                    var options = {
                        'startSelector': '#cb_cruise_date_selector',
                        'onSelect': function () {
                            dayofWeekElement.empty().html($.format(dateElement.datepicker("getDate"), 'dddd'));
                        }
                    };

                    dateElement.singledatepicker(options);
                    dateElement.tipsy({ trigger: 'manual', gravity: 's', offset: 6 });

                    triggerElement.click(function () {
                        dateElement.singledatepicker('show');
                    });





                })(citybreakjq);
                (function ($, undefined) {



                    var dropDownOptions = {
                        'pleaseChooseMessage': '请输入你在哪里离开',
                        'type': 'cb_cruise_package_dropdown'
                    };

                    $('#cb_cruise_package_dropdown').dropdownselector(dropDownOptions);




                })(citybreakjq);
                (function ($, undefined) {



                    var selectorOptions = {
                        'placementRequestSelector': '#cb_cruise_passengerstring_0',
                        'selectedNumberOfAdultsSelectorPrefix': '#cb_cruise_numAdults_0',
                        'selectedNumberOfChildrenSelectorPrefix': '#cb_cruise_numChild_0',
                        'childAgeSelectorPrefix': '#cb_cruise_childage_0',
                        'childAgeContainerSelectorPrefix': '#cb_cruise_childage_cont_0',
                        'invalidChildAgesValidationMessage': "请输入之间的婴幼儿的年龄0和17",
                        'pleaseFillInChildAgesMessage': "请输入每个儿童的年龄（在行程时间）",
                        'minChildAge': 0,
                        'maxChildAge': 17
                    };

                    $("#roomConfigurations_passengerselector0").passengerselector(selectorOptions);




                })(citybreakjq);
                (function ($, undefined) {



                    $('#cb_cruise_searchbutton').click(function (e) {
                        e.preventDefault();

                        var validDatePicker = $("#cb_cruise_date_date").singledatepicker('isValid');

                        var validPassengers = $("#roomConfigurations_passengerselector0").passengerselector('isValid');

                        var validPackage = $('#cb_cruise_package_dropdown').dropdownselector('isValid');

                        var form;
                        if (validDatePicker && validPassengers && validPackage) {

                            form = $(this).closest('form');

                            // append trackers
                            citybreakCommonSearchForm.appendTrackers(form);

                            form.submit();
                        }
                    });

                    $('.Citybreak_change_link').click(function () {
                        if (($.browser.msie && $.browser.version === "7.0")) {
                            $('#Citybreak_cruise_bookingform').show();
                            $('#Citybreak_cruise_bookingdetails').hide();
                        } else {
                            $('#Citybreak_cruise_bookingform').slideDown();
                            $('#Citybreak_cruise_bookingdetails').slideUp();
                        }
                    });




                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_cruise_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_cruise_searchform_widget, executing');

            var target = citybreakjq('#citybreak_cruise_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_cruise_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_cruise_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_cruise_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_cruise_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_event_searchform_widget', function () {
            console.log('onContentReady #citybreak_event_searchform_widget, executing');

            var target = document.getElementById('citybreak_event_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_event_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_event_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_event_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine\">\r\n\t<div class=\"Citybreak_SidebarBox Citybreak_Search cb_event_searchbox\">\r\n\t\t<div class=\"cb_inner\">\r\n\t\t\t<div class=\"cb_ex\"></div>\r\n\t\t\t<div class=\"cb_hd\">\r\n\t\t\t\t<h4>搜索与预订</h4>\r\n\t\t\t\t<span class=\"cb_ex_label\" title=\"事件\">事件</span>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_bd\">\r\n\t\t\t\t<form action=\"http://online3-next.citybreak.com/537027515/zh/eventsearch/search?redirto=Index\" method=\"post\" id=\"cb_ev_bookingform\" >\t\r\n\t\t\t\t\t<div class=\"cb_copy cb_clr\">\r\n\t\t\t\t\t\t<div class=\"Citybreak_SearchBox\">\r\n\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ev_section_datepicker\">\r\n\t\t\t\t\t\t\t\t<div class=\"cb_col_left_w2 cb_selects_w4\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">从:</label>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_date_input\">\r\n\t\t\t\t\t\t\t\t\t    <label>\r\n                                            <span class=\"cb_ev_datefrom_label\" style=\"display: none;\">\r\n                                                <span class=\"cb_ev_datefrom_day\"></span>\r\n                                                <span class=\"cb_ev_datefrom_month\"></span>\r\n                                                <span class=\"cb_ev_datefrom_year\"></span>\r\n                                            </span> \r\n\t\t\t\t\t\t\t\t\t        <input type=\"text\" id=\"cb_ev_form_datefrom\" name=\"start\" class=\"cb_validate_startdate cb_validate_required\" value=\"2019-06-18\"/>\r\n\t\t\t\t\t\t\t\t\t    </label>\r\n\t\t\t\t\t\t\t\t\t\t<a class=\"cp_cal_trig_from\" id=\"cb_ev_trigger_from\"></a>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ev_section_lenght\">\r\n\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"period\" value=\"\" checked='checked' />\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">及之后数日</span>\r\n\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"period\" value=\"d\"  />\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">仅选定日期</span>\r\n\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"period\" value=\"w\"  />\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">一周</span>\r\n\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"period\" value=\"t\"  />\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">直至</span>\r\n\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row\" id=\"cb_ev_dateto_container\" style=\"display:none;\">\r\n\t\t\t\t\t\t\t\t<div class=\"cb_col_left_w2 cb_selects_w4\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">至:</label>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_date_input\">\r\n\t\t\t\t\t\t\t\t\t    <label>\r\n                                            <span class=\"cb_ev_dateto_label\" style=\"display: none;\">\r\n                                                <span class=\"cb_ev_dateto_day\"></span>\r\n                                                <span class=\"cb_ev_dateto_month\"></span>\r\n                                                <span class=\"cb_ev_dateto_year\"></span>\r\n                                            </span>\r\n\t\t\t\t\t\t\t\t\t        <input type=\"text\" id=\"cb_ev_form_dateto\" class=\"cb_validate_enddate\" name=\"end\"/>\r\n\t\t\t\t\t\t\t\t\t    </label>\r\n\t\t\t\t\t\t\t\t\t\t<a class=\"cp_cal_trig_from\" id=\"cb_ev_trigger_to\"></a>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t<div class=\"cb_btn cb_clr\" id=\"cb_ev_srch_btn1\">\r\n\t\t\t\t\t\t<input type=\"submit\" class=\"Citybreak_Button cb_searchbutton\" id=\"cb_ev_SearchButton\" value=\"搜索\" />\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</form>\r\n\r\n\t\t\t\t\t<div id=\"cb_ev_bookingdetails\" style=\"display: none;\">\r\n\t\t\t\t\t\t<div class=\"cb_search_summary\">\r\n\t\t\t\t\t\t\t<div class=\"cb_copy\">\r\n\t\t\t\t\t\t\t\t<ul>\r\n\t\t\t\t\t\t\t\t\t<li>\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_lbl\">Search from:</span>\r\n\t\t\t\t\t\t\t\t\t\t周二 18 6月 2019\r\n\t\t\t\t\t\t\t\t\t</li>\r\n\t\t\t\t\t\t\t\t\t<li>\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_lbl\">Search:</span>\r\n\t\t\t\t\t\t\t\t\t\t及之后数日\r\n\t\t\t\t\t\t\t\t\t</li>\r\n\t\t\t\t\t\t\t\t</ul>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t<div class=\"cb_btn cb_clr\">\r\n\t\t\t\t\t\t\t<a href=\"javascript:;\" class=\"Citybreak_change_link\" id=\"cb_ev_changebooking\">\r\n\t\t\t\t\t\t\t\t<span class=\"cb_icon cb_expandicon\"></span>Change search\r\n\t\t\t\t\t\t\t</a>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_ft\"></div>\r\n\t\t</div>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_event_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_event_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {

                    var initStartDate = new Date(2019, 5, 18, 0, 0, 0, 0);
                    var initEndDate = new Date(2019, 6, 18, 0, 0, 0, 0);
                    var minStartDate = new Date(2019, 5, 18, 13, 21, 10, 523);

                    var validationMessages = {
                        start: 'Invalid date',
                        end: 'Invalid date',
                        CookieAlert: 'Warning! Cookies are disabled. '
                    };

                    citybreakEventSearchForm.initSearchForm(initStartDate, initEndDate, minStartDate, validationMessages);

                    $('#cb_ev_SearchButton').click(function (e) {
                        e.preventDefault();
                        if ($("#cb_ev_form_datefrom").val().length > 0) {
                            citybreakEventSearchForm.post('http://online3-next.citybreak.com/537027515/zh/eventsearch/search?redirto=Index');
                        }
                    });


                    var mapViewUrl = 'http://online3-next.citybreak.com/537027515/zh/accommodationwidget/mapview';
                    $('#cb_show_mapview_event').citybreakMapView({ mapContainerSelector: '#cb_mapcontainer', mapViewUrl: mapViewUrl });



                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_event_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_event_searchform_widget, executing');

            var target = citybreakjq('#citybreak_event_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_event_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_event_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_event_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_event_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_ferry_searchform_widget', function () {
            console.log('onContentReady #citybreak_ferry_searchform_widget, executing');

            var target = document.getElementById('citybreak_ferry_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_ferry_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_ferry_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_ferry_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "\r\n\r\n\r\n\r\n\r\n\r\n<div class=\"Citybreak_engine\">\r\n\t<div class=\"Citybreak_SidebarBox Citybreak_Search cb_ferry_searchbox cb-js-ferry-search-form\">\r\n\t\t<div class=\"cb_inner\">\r\n\t\t\t<div class=\"cb_ex\"></div>\r\n\t\t\t<div class=\"cb_hd\">\r\n\t\t\t\t<h4>渡口</h4>\r\n\t\t\t\t<span class=\"cb_ex_label\" title=\"渡口\">渡口</span>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_bd\">\r\n\t\t\t\r\n\t\t\t\t<form action=\"http://online3-next.citybreak.com/537027515/zh/ferrysearch/search\" method=\"post\" name=\"cb_ns_ferry_search\">\r\n\t\t\t\r\n\t\t\t\t\t<div id=\"Citybreak_ferry_bookingform\" class=\"\">\r\n\r\n\r\n                        <div class=\"cb-js-loading-overlay cb-loading-block\" style=\"display: none; position: absolute; top: 0; right: 0; bottom: 0; left: 0; z-index: 100;\">\r\n                            <span></span>\r\n                        </div>\r\n\r\n\r\n\t\t\t\t\t    <input type=\"hidden\" id=\"cb_ferry_passengers\" value=\"\" name=\"cb_ferry_passengers\" />\r\n\t\t\t\t\t\r\n\t\t\t\t\t\t<div class=\"cb_copy cb_clr\">\r\n\t\t\t\t\t\t\t<div class=\"Citybreak_SearchBox\">\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_ac_section_showon_list\">\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ev_section_lenght\">\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t\t\t<label>\r\n                                                <input title=\"往返\" name=\"cb_ferry_triptype\" type=\"radio\" value=\"roundtrip\" id=\"cb_ferry_triptype_roundtrip\" \tchecked=checked\r\n />\r\n                                                <span class=\"cb_radio_lbl\">往返</span>\r\n                                            </label>\r\n\t\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t\t\t<label>\r\n                                                <input title=\"单程\" type=\"radio\" name=\"cb_ferry_triptype\" value=\"oneway\" id=\"cb_ferry_triptype_oneway\"  />\r\n                                                <span class=\"cb_radio_lbl\">单程</span>\r\n                                            </label>\r\n\t\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row\" id=\"cb_form_ferry_oneway_section\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">Outward journey:</label>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_selects cb_selects_wide\">\r\n\t\t\t\t\t\t\t\t\t\t<select class=\"cb-js-one-way\" id=\"cb_ferry_onewaytrip\" name=\"cb_ferry_onewaytrip\"  title=\"出港\">\r\n\t\t\t\t\t\t\t\t\t\t\t<option value=\"\" \tselected=\"selected\"\r\n>选择呼出路由</option>\r\n\t\t\t\t\t\t\t\t\t\t</select>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row\" id=\"cb_form_ferry_roundtrip_section\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">Outward journey:</label>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_selects cb_selects_wide\">\r\n\t\t\t\t\t\t\t\t\t\t<select class=\"cb-js-roundtrip\" id=\"cb_ferry_roundtrip\" name=\"cb_ferry_roundtrip\"  title=\"出港\">\r\n\t\t\t\t\t\t\t\t\t\t\t<option value=\"\" \tselected=\"selected\"\r\n>选择呼出路由</option>\r\n\t\t\t\t\t\t\t\t\t\t</select>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_2col cb_ac_section_dates\">\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_col_left\">\r\n\t\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">出发日期:</label>\r\n\t\t\t\t\t\t\t\t\t\t<div class=\"cb_date_input\">\r\n\t\t\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t\t\t<input title=\"出发日期\" name=\"cb_ferry_startdate\" type=\"text\" id=\"cb_ferry_datefrom\"  value=\"2019/6/18\"/>\r\n\t\t\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t\t\t\t<a class=\"cp_cal_trig_from\" id=\"cb_ferry_trigger_datefrom\" title=\"出发日期\"></a>\r\n\t\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_byline\" id=\"cb_ferry_datefrom_byline\"></span>\r\n\t\t\t\t\t\t\t\t\t</div>\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_col_right\" id=\"cb_ferry_returningdate_cont\">\r\n\t\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">回国日期:</label>\r\n\t\t\t\t\t\t\t\t\t\t<div class=\"cb_date_input\"><label><input title=\"回国日期\" name=\"cb_ferry_enddate\" type=\"text\" id=\"cb_ferry_dateto\"  value=\"2019/6/19\"/></label><a class=\"cp_cal_trig_from\" id=\"cb_ferry_trigger_dateto\" title=\"回国日期\"></a></div>\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_byline\" id=\"cb_ferry_returningdate_byline\"></span>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t<div class=\"cb_col_left\">\r\n\t\t\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">乘客:</label>\r\n\t\t\t\t\t\t\t\t\t\t\t<select id=\"cb_ferry_numAdults\" title=\"成人\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"1\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t1 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"2\" selected='selected'>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t2 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"3\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t3 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"4\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t4 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"5\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t5 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"6\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t6 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"7\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t7 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"8\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t8 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"9\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t9 成人\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t</select>\r\n\t\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t\t<div class=\"cb_col_right\">\r\n\t\t\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">&nbsp;</label>\r\n\t\t\t\t\t\t\t\t\t\t\t<select id=\"cb_ferry_numChild\" onchange=\"citybreakFerrySearchForm.onChildChange()\" title=\"孩子\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"0\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t0 孩子\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"1\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t1 孩子\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"2\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t2 孩子\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"3\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t3 孩子\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"4\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t4 孩子\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"5\" >\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t5 孩子\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t</select>\r\n\t\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_hidden cb_ac_section_room_childages\" id=\"cb_ferry_childage_cont\" >\r\n\t\t\t\t\t\t\t\t\t\t<div class=\"cb_fields cb_children cb_hidden\">\r\n\t\t\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t儿童的年龄 (0-17)\r\n\t\t\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show1 cb_hidden\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t1:</span><label for=\"cb_ferry_childage_1\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_ferry_childage_1\" name=\"cb_ferry_childage_1\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t\t\t\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show2 cb_hidden\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t2:</span><label for=\"cb_ferry_childage_2\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_ferry_childage_2\" name=\"cb_ferry_childage_2\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t\t\t\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show3 cb_hidden\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t3:</span><label for=\"cb_ferry_childage_3\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_ferry_childage_3\" name=\"cb_ferry_childage_3\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t\t\t\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show4 cb_hidden\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t4:</span><label for=\"cb_ferry_childage_4\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_ferry_childage_4\" name=\"cb_ferry_childage_4\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t\t\t\t\t\t\t\t<div class=\"cb_childage_input cb_childage_show5 cb_hidden\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_child_lbl\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t5:</span><label for=\"cb_ferry_childage_5\"><input\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttype=\"text\" title=\"每个儿童的年龄（在行程时间）\" value=\"\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tid=\"cb_ferry_childage_5\" name=\"cb_ferry_childage_5\"\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmaxlength=\"2\" /></label></div>\r\n\t\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n                                \r\n                                <div class=\"cb-js-person-vehicle-groups\">\r\n\t\t\t\t\t\t\t\t    \r\n<div class=\"cb_form_row cb_ferry_form_vehicle\" id=\"cb_ferry_form_vehicles\">\r\n    <label class=\"cb_titlelabel\">选车:</label>\r\n\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-0\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-1\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-2\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-3\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-4\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-5\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-6\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-7\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-8\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n        <div class=\"cb_selects cb_selectwithicon cb_ferry_form_vehicle cb_js_ferry_form_vehicle\">\r\n            <select name=\"cb_ferry_vehicle\" title=\"车辆号\" id=\"cb-js-vehicles-9\">\r\n                <option value=\"\" \tselected=\"selected\"\r\n>车辆号</option>\r\n            </select>\r\n                <a href=\"javascript:;\" class=\"cb_ferry_form_vehicle_delete\" title=\"除去车辆\"><span class=\"cb_icon cb_removeicon\" title=\"删除\"></span></a>\r\n            \r\n        </div>\r\n    <div class=\"cb_addnew\">\r\n        <a href=\"javascript:;\" id=\"cb_ferry_form_vehicle_add\"><span class=\"cb_icon cb_addicon\"></span><span class=\"cb_caticon cb_addvehicle\"></span>新增车辆</a>\r\n    </div>\r\n\r\n</div>\r\n\r\n                                </div>\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t<div class=\"cb_btn cb_clr\">\r\n\t\t\t\t\t\t\t<a href=\"#\" class=\"Citybreak_Button cb_searchbutton\" id=\"cb_ferry_searchbutton\" title=\"搜索\">搜索</a>\r\n\t\t\t\t\t\t\t<input type=\"submit\" value=\"搜索\" id=\"cb_ns_ferry_submitbtn\" class=\"cb_ns_submitbtn\" title=\"搜索\" style=\"display: none;\" />\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</form>\r\n\r\n\t\t   \r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_ft\"></div>\r\n\t\t</div>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_ferry_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_ferry_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {

                    var validationMessages = {};

                    validationMessages.EmptyDestinationLocation = "请输入你在哪里离开";
                    validationMessages.EmptyGoingToDestination = "请输入您的目的地";
                    validationMessages.SameStartAndEndIATACode = "你的目标必须是从您的出发城市不同";
                    validationMessages.InvalidDepartureDate = "出发日期无效";
                    validationMessages.DepartureDateHasPassed = "出发日期已过";
                    validationMessages.InvalidReturningDate = "返回日期无效";
                    validationMessages.ReturningDateShouldBeGreaterThanDepartureDate = "返回日期必须晚于出发日期";
                    validationMessages.ReturningDateHasPassed = "返回日期已过";
                    validationMessages.InvalidChildAges = "请输入之间的婴幼儿的年龄1和17";
                    validationMessages.PleaseFillInChildAges = "请输入每个儿童的年龄（在行程时间）";
                    validationMessages.PleaseChooseDepartureLocation = "请输入你在哪里离开";
                    validationMessages.PleaseChooseGoingToDestination = "请输入您的目的地";

                    validationMessages.PleaseChooseAVehicle = "请选择车辆";
                    validationMessages.PleaseChooseAPassenger = "请选择客运型";

                    validationMessages.Day = "日";
                    validationMessages.Days = "天";
                    validationMessages.CookieAlert = "Warning! Cookies are disabled. ";

                    var ferrySearchConfiguration = citybreakCommonSearchForm.getFerrySearchConfiguration(
                        new Date(2019, 5, 18, 13, 21, 10, 570),
                        new Date(1560943270570),
                        new Date(2019, 5, 18, 13, 21, 10, 570)
                    );

                    var ferrySearchFormUrls = {
                        "getArrivalIataSpots": "http://online3-next.citybreak.com/537027515/zh/ferry/getarrivaliataspots",
                        "getDepartureIataSpots": "http://online3-next.citybreak.com/537027515/zh/ferry/getdepartureiataspots",
                        "newSearch": "http://online3-next.citybreak.com/537027515/zh/ferrysearch/search",
                        "priceGruopsUrl": "http://online3-next.citybreak.com/537027515/zh/ferry/getstartpagepersonandvehiclepricegroups"
                    };

                    var ferrySearchFormLocalizedText = {
                        "AutoCompleteNoResults": "没有结果",
                        "AutoCompleteTheresMoreByLine": "还有更多的结果"
                    };

                    var messages = validationMessages;
                    var pickupDate = ferrySearchConfiguration.departureDate;
                    var dropOffDate = ferrySearchConfiguration.returnDate;
                    var direction = 0;
                    var flightSearchFormUrls = ferrySearchFormUrls;
                    var shouldExpandForm = true;
                    var nrOfSelectedPassengers = 0;
                    var nrOfSelectedVehicles = 0;
                    var minChildAgez = 0;
                    var maxChildAgez = 17;
                    var tripType = "roundtrip";
                    var minDate = new Date(2019, 5, 18, 13, 21, 10, 570);
                    var addNumberOfDays = 1;

                    citybreakFerrySearchForm.initializeSearchForm(
                        messages,
                        pickupDate,
                        dropOffDate,
                        direction,
                        flightSearchFormUrls,
                        shouldExpandForm,
                        nrOfSelectedPassengers,
                        nrOfSelectedVehicles,
                        minChildAgez,
                        maxChildAgez,
                        tripType,
                        minDate,
                        addNumberOfDays);



                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_ferry_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_ferry_searchform_widget, executing');

            var target = citybreakjq('#citybreak_ferry_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_ferry_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_ferry_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_ferry_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_ferry_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_flight_searchform_widget', function () {
            console.log('onContentReady #citybreak_flight_searchform_widget, executing');

            var target = document.getElementById('citybreak_flight_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_flight_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_flight_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_flight_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine\">\r\n    <div class=\"Citybreak_SidebarBox Citybreak_Search cb_flight_searchbox\" id=\"cb_flightsearchform_main\">\r\n\r\n        <input type=\"hidden\" id=\"cb_flight_startIATACode\" name=\"cb_dropOffCode\" />\r\n        <input type=\"hidden\" id=\"cb_flight_startSelection\" />\r\n        <input type=\"hidden\" id=\"cb_flight_startLocationNameId\" value=\"\" name=\"cb_dropOffLocationNameId\" />\r\n\r\n        <input type=\"hidden\" id=\"cb_flight_endSelection\" value=\"\" />\r\n        <input type=\"hidden\" id=\"cb_flight_endIATACode\" value=\"\" name=\"cb_pickUpCode\" />\r\n        <input type=\"hidden\" id=\"cb_flight_endLocationNameId\" value=\"\" name=\"cb_pickUpLocationNameId\" />\r\n\r\n        <input type=\"hidden\" id=\"cb_flight_passengers\" value=\"\" name=\"pr\" />\r\n\r\n        <div class=\"cb_inner\">\r\n            <div class=\"cb_ex\">\r\n            </div>\r\n            <div class=\"cb_hd\">\r\n                <h4>搜索与预订</h4>\r\n                <span class=\"cb_ex_label\" title=\"机票\">机票</span>\r\n            </div>\r\n            <div class=\"cb_bd\">\r\n\r\n                <div id=\"Citybreak_flight_bookingform\" class=\"\">\r\n                    <div class=\"cb_copy cb_clr\">\r\n                        <div class=\"Citybreak_SearchBox\">\r\n\r\n                                <div class=\"cb_form_row cb_ac_section_showon_list\">\r\n        <strong>旅行类型:</strong>\r\n        <div class=\"cb_radio\">\r\n            <label>\r\n                <input title=\"往返\" name=\"cb_triptype\" type=\"radio\" value=\"roundtrip\" id=\"cb_triptype_roundtrip\" checked=checked />\r\n                <span class=\"cb_radio_lbl\">往返</span>\r\n            </label>\r\n        </div>\r\n        <div class=\"cb_radio\">\r\n            <label>\r\n                <input title=\"单程\" type=\"radio\" name=\"cb_triptype\" value=\"oneway\" id=\"cb_flight_triptype_oneway\"  />\r\n                <span class=\"cb_radio_lbl\">单程</span>\r\n            </label>\r\n        </div>\r\n    </div>\r\n\r\n<div class=\"Citybreak_engine cb-widget-search\">\r\n    <div class=\"cb-block cb-block-destination\">\r\n\r\n            <div class=\"cb_form_row cb_ac_section_keyword\">\r\n                <label class=\"cb_titlelabel\"><strong>去:</strong></label>\r\n                <div class=\"cb_keyword_input\"><label><input title=\"去\" type=\"text\" name=\"cb_flight_ac_goingto\" id=\"cb_flight_ac_goingto\" /></label></div>\r\n            </div>\r\n            <div id=\"cb_flight_ac_goingto_noresult\" class=\"cb_noresults_msg\"></div>\r\n\r\n            <div class=\"cb_form_row cb_ac_section_keyword\">\r\n                <label class=\"cb_titlelabel\"><strong>离开:</strong></label>\r\n                <div class=\"cb_keyword_input\">\r\n                    <label>\r\n                        <input title=\"离开\" type=\"text\" name=\"cb_flight_ac_leavingfrom\" id=\"cb_flight_ac_leavingfrom\" />\r\n                    </label>\r\n                </div>\r\n            </div>\r\n            <div id=\"cb_flight_ac_leavingfrom_noresult\" class=\"cb_noresults_msg\"></div>\r\n\r\n    </div>\r\n</div>\r\n\r\n\r\n                            <div class=\"cb_form_row cb_2col cb_ac_section_dates\">\r\n                                <div class=\"cb_col_left\">\r\n                                    <label class=\"cb_titlelabel\">出发日期:</label>\r\n                                    <div class=\"cb_date_input\"><label><input title=\"出发日期\" name=\"startdate\" type=\"text\" id=\"cb_flight_datefrom\" /></label><a class=\"cp_cal_trig_from\" id=\"cb_flight_trigger_datefrom\" title=\"软座日期\"></a></div>\r\n                                    <span class=\"cb_byline\" id=\"cb_flight_datefrom_byline\"></span>\r\n                                </div>\r\n                                <div class=\"cb_col_right\" id=\"cb_flight_returningdate_cont\">\r\n                                    <label class=\"cb_titlelabel\">回国日期:</label>\r\n                                    <div class=\"cb_date_input\"><label><input title=\"回国日期\" name=\"enddate\" type=\"text\" id=\"cb_flight_dateto\" /></label><a class=\"cp_cal_trig_from\" id=\"cb_flight_trigger_dateto\" title=\"回国日期\"></a></div>\r\n                                    <span class=\"cb_byline\" id=\"cb_flight_returningdate_byline\"></span>\r\n                                </div>\r\n                            </div>\r\n\r\n\r\n                            <div class=\"cb_form_row cb_ac_section_nodates\" id=\"cb_flight_flexibledates_cnt\">\r\n                                <div class=\"cb_checkbox\">\r\n                                    <label>\r\n                                        <input type=\"checkbox\" title=\"+ /  -  3天数\" name=\"Citybreak_flexibledates\" id=\"Citybreak_flexibledates\"  /><span class=\"cb_checkbox_lbl\">+ /  -  3天数</span>\r\n                                    </label>\r\n                                </div>\r\n                            </div>\r\n\r\n\r\n\r\n                            <div class=\"cb_form_row\">\r\n                                <div>\r\n                                    <label class=\"cb_titlelabel\">乘客:</label>\r\n                                    <div>\r\n                                        <label class=\"cb-form-icon cb-icon-caret cb-js-select-passengers\">\r\n                                            <span class=\"cb-form-text\">\r\n                                                <span class=\"cb-icnlbl cb-icnlbl-person\">\r\n                                                    <span class=\"cb-js-number-of-selected-passengers\">2 <span>travelers </span></span>\r\n                                                </span>\r\n                                            </span>\r\n                                        </label>\r\n                                    </div>\r\n                                </div>\r\n                                <div class=\"cb-popout cb-guestconfig cb-with-actions cb-js-passengers-selection\">\r\n                                    <div class=\"cb-popout-content cb-clr\">\r\n                                        <div class=\"cb-guest-rows\">\r\n                                            <h3>Add number of travelers</h3>\r\n                                            <table>\r\n                                                <tbody>\r\n                                                            <tr>\r\n                                                                <td class=\"cb-cell-title\">\r\n                                                                    <div>\r\n                                                                        Adult:\r\n                                                                    </div>\r\n                                                                </td>\r\n                                                                <td>\r\n                                                                    <select class=\"selector cb-form-select cb-js-passenger-selector\" name=\"140\"><option selected=\"selected\" value=\"0\">0 travelers</option>\r\n<option value=\"1\">1 traveler</option>\r\n<option selected=\"selected\" value=\"2\">2 travelers</option>\r\n<option value=\"3\">3 travelers</option>\r\n<option value=\"4\">4 travelers</option>\r\n<option value=\"5\">5 travelers</option>\r\n<option value=\"6\">6 travelers</option>\r\n<option value=\"7\">7 travelers</option>\r\n<option value=\"8\">8 travelers</option>\r\n<option value=\"9\">9 travelers</option>\r\n</select>\r\n                                                                </td>\r\n                                                            </tr>\r\n                                                            <tr>\r\n                                                                <td class=\"cb-cell-title\">\r\n                                                                    <div>\r\n                                                                        Child:\r\n                                                                    </div>\r\n                                                                </td>\r\n                                                                <td>\r\n                                                                    <select class=\"selector cb-form-select cb-js-passenger-selector\" name=\"141\"><option selected=\"selected\" value=\"0\">0 travelers</option>\r\n<option value=\"1\">1 traveler</option>\r\n<option value=\"2\">2 travelers</option>\r\n<option value=\"3\">3 travelers</option>\r\n<option value=\"4\">4 travelers</option>\r\n<option value=\"5\">5 travelers</option>\r\n<option value=\"6\">6 travelers</option>\r\n<option value=\"7\">7 travelers</option>\r\n<option value=\"8\">8 travelers</option>\r\n<option value=\"9\">9 travelers</option>\r\n</select>\r\n                                                                </td>\r\n                                                            </tr>\r\n                                                        <tr>\r\n                                                            <td class=\"cb-row-ages\" colspan=\"2\">\r\n                                                                <span>* Refers to the age at the time of homebound</span>\r\n                                                            </td>\r\n                                                        </tr>\r\n\r\n                                                </tbody>\r\n                                            </table>\r\n                                        </div>\r\n                                        <div class=\"cb-popout-actions cb-clr\">\r\n                                            <a href=\"javascript:void(0);\" class=\"cb-btn cb-btn-light cb-js-abort-selection\">Cancel</a>\r\n                                            <a href=\"javascript:void(0);\" class=\"cb-btn cb-js-confirm-passengers\">Done</a>\r\n                                        </div>\r\n                                    </div>\r\n                                </div>\r\n                            </div>\r\n\r\n\r\n\r\n\r\n                            \r\n\r\n                        </div>\r\n\r\n                    </div>\r\n\r\n                    <div class=\"cb_btn cb_clr\">\r\n                        <a href=\"http://online3-next.citybreak.com/537027515/zh/flightsearch/search\" class=\"Citybreak_Button cb_searchbutton\" id=\"cb_flight_searchbutton\" title=\"搜索\">搜索 </a>\r\n                    </div>\r\n\r\n                </div>\r\n\r\n\r\n            </div>\r\n            <div class=\"cb_ft\">\r\n            </div>\r\n        </div>\r\n    </div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_flight_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_flight_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {

                    var validationMessages = {};

                    validationMessages.EmptyDestinationLocation = "请输入你在哪里离开";
                    validationMessages.EmptyGoingToDestination = "请输入您的目的地";
                    validationMessages.SameStartAndEndIATACode = "你的目标必须是从您的出发城市不同";
                    validationMessages.InvalidDepartureDate = "出发日期无效";
                    validationMessages.DepartureDateHasPassed = "出发日期已过";
                    validationMessages.InvalidReturningDate = "返回日期无效";
                    validationMessages.ReturningDateShouldBeGreaterThanDepartureDate = "返回日期必须晚于出发日期";
                    validationMessages.ReturningDateHasPassed = "返回日期已过";
                    validationMessages.InvalidChildAges = "请输入之间的婴幼儿的年龄0和11";
                    validationMessages.PleaseFillInChildAges = "请输入每个儿童的年龄（在行程时间）";
                    validationMessages.PleaseChooseDepartureLocation = "请输入你在哪里离开";
                    validationMessages.PleaseChooseGoingToDestination = "请输入您的目的地";
                    validationMessages.InvalidNumberOfTotalPersons = "You can only search for max {0} persons at a time.";
                    validationMessages.InvalidNumberOfAdults = "Invalid number of adults";

                    validationMessages.Day = "日";
                    validationMessages.Days = "天";
                    validationMessages.CookieAlert = "Warning! Cookies are disabled. ";

                    var flightSearchConfiguration = citybreakCommonSearchForm.getFlightSearchConfiguration(
                    new Date(2019, 5, 18, 13, 21, 10, 570),
                    new Date(2019, 5, 19, 13, 21, 10, 570),
                    2,
                    new Date(2019, 5, 18, 13, 21, 10, 617)
                    );

                    var flightSearchFormUrls = {
                        "getArrivalIataSpots": 'http://online3-next.citybreak.com/537027515/zh/flight/getarrivaliataspots',
                        "getDepartureIataSpots": "http://online3-next.citybreak.com/537027515/zh/flight/getdepartureiataspots"
                    };

                    var flightSearchFormLocalizedText = {
                        "AutoCompleteNoResults": '没有结果',
                        "AutoCompleteTheresMoreByLine": "还有更多的结果"
                    };

                    var validationSettings = {};
                    validationSettings.RequireLeavingFrom = true;
                    validationSettings.RequireGoingTo = true;
                    validationSettings.MinimumChildAge = 0;
                    validationSettings.MaximumChildAge = 11;
                    validationSettings.MaximumNumberOfTotalPersons = 30;

                    var passengersTranslation = {};
                    passengersTranslation.singular = 'traveler';
                    passengersTranslation.plural = 'travelers';

                    citybreakFlightSearchForm.initializeSearchForm(
                    validationMessages,
                    flightSearchConfiguration.departureDate,
                    flightSearchConfiguration.returnDate,
                    new Date(2019, 5, 19, 13, 21, 10, 617),
                    0,
                    flightSearchFormUrls,
                    flightSearchFormLocalizedText,
                    true,
                    validationSettings,
                    new Date(2019, 5, 18, 13, 21, 10, 617),
                    1,
                    "地区，地标或机场",
                    "地区，地标或机场",
                    false,
                    passengersTranslation
                    );


                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_flight_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_flight_searchform_widget, executing');

            var target = citybreakjq('#citybreak_flight_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_flight_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_flight_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_flight_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_flight_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_multi_searchform_widget', function () {
            console.log('onContentReady #citybreak_multi_searchform_widget, executing');

            var target = document.getElementById('citybreak_multi_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_multi_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_multi_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_multi_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"cb_multiwidget\" id=\"Citybreak_MultiWidget\">\r\n\t<div class=\"cb_inner\">\r\n\t\t<ul class=\"cb_list\">\r\n\t\t\t\t<li class=\"cb_item cb_accommodationsearchform cb_active\">\r\n                    <a href=\"javascript:;\" title=\"住宿\">\r\n                        <span class=\"cb_icon cb_accommodationsearchform\"></span>\r\n                        <span class=\"cb_lbl\">住宿</span>\r\n                    </a>\r\n\t\t\t\t</li>\r\n\t\t\t\t<li class=\"cb_item cb_eventsearchform \">\r\n                    <a href=\"javascript:;\" title=\"活动\">\r\n                        <span class=\"cb_icon cb_eventsearchform\"></span>\r\n                        <span class=\"cb_lbl\">活动</span>\r\n                    </a>\r\n\t\t\t\t</li>\r\n\t\t</ul>\r\n\t\t\t\r\n\t\t<div class=\"cb_widgets\">\r\n\t\t\t\t<div class=\"cb_widget cb_accommodationsearchform \">\r\n\t\t\t\t\t<h2>搜索并预订的住宿</h2>\r\n\r\n\r\n\r\n<div class=\"Citybreak_engine\">\r\n\t<div class=\"Citybreak_SidebarBox Citybreak_Search cb_accommodation_searchbox\">\r\n\t\t<div class=\"cb_inner\">\r\n\t\t\t<div class=\"cb_ex\"></div>\r\n\t\t\t<div class=\"cb_hd\">\r\n\t\t\t\t<h4>搜寻酒店</h4>\r\n\t\t\t\t<span class=\"cb_ex_label\" title=\"住宿\">住宿</span>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_bd\">\r\n\t\t\t\r\n\r\n\r\n<div id=\"Citybreak_bookingdetails\" class=\"cb_hidden\">\r\n\t<div class=\"cb_search_summary\">\r\n\t\t<div class=\"cb_copy\">\r\n\t\t\t<ul>\r\n\t\t\t\t\r\n\t\t\t\t\r\n\r\n\t\t\t\t    <li class=\"cb_acc_type\">\r\n\t\t\t\t\t    <span class=\"cb_lbl\">住宿类型:</span>\r\n\t\t\t\t\t    所有\r\n\t\t\t\t    </li>\r\n\r\n\r\n\r\n\r\n\t\t\t\t<li>\r\n\t\t\t\t\t<span class=\"cb_lbl\">\r\n                            入住:\r\n\t\t\t\t\t</span>\r\n\t\t\t\t\t周三 19 6月 2019\r\n\t\t\t\t</li>\r\n\r\n\t\t\t\t    <li>\r\n\t\t\t\t\t    <span class=\"cb_lbl\">退房:</span>\r\n\t\t\t\t\t    周三 26 6月 2019\r\n\t\t\t\t    </li>\r\n\t\t\t\t    <li>\r\n\t\t\t\t\t    <span class=\"cb_lbl\">夜:</span>\r\n\t\t\t\t\t    7\r\n\t\t\t\t    </li>\r\n\r\n\r\n\r\n\t\t\t\t    <li>\r\n\t\t\t\t\t    <span class=\"cb_lbl\">客房:</span>\r\n\t\t\t\t\t    1\r\n\t\t\t\t    </li>\r\n\r\n\t\t\t\t<li>\r\n\t\t\t\t\t<span class=\"cb_lbl\">宾客:</span>\r\n\t\t\t\t\t2\r\n\r\n\t\t\t\t\t成人\r\n\t\t\t\t    \r\n\t\t\t\t</li>\r\n\t\t\t\t\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t</ul>\r\n\t\t</div>\r\n\t</div>\r\n\t<div class=\"cb_btn cb_clr\">\r\n\t\t<a href=\"javascript:;\" class=\"Citybreak_change_link\" id=\"Citybreak_changebooking\" title=\"更改搜索\">\r\n\t\t\t<span class=\"cb_icon cb_expandicon\"></span><span>更改搜索</span>\r\n\t\t</a>\r\n\t</div>\r\n</div>\r\n\t\t\t\r\n<form action=\"http://online3-next.citybreak.com/537027515/zh/accommodationsearch/search\" method=\"post\" id=\"form1\" accept-charset=\"UTF-8\" name=\"basketFormDelete\">\t\t\t\t\t<input type=\"hidden\" id=\"cb_searchstring\" value=\"2\" name=\"pr\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_discountCategoryId\" value=\"\" name=\"discountCategoryId\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_packageLightCategoryId\" value=\"\" name=\"packageLightCategoryId\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_discountId\" value=\"\" name=\"discountId\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_poiId\" value=\"\" name=\"cb_poiId\" />\r\n                    <input type=\"hidden\" id=\"cb_geoId\" value=\"\" name=\"cb_geoId\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_locationAttribute\" value=\"\" name=\"cb_locationAttribute\"/>\t\t\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_city\" value=\"\" name=\"cb_city\" />\r\n\t\t\t\t\t<input type=\"hidden\" value=\"false\" name=\"islockedbycategory\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_distanceLimit\" value=\"\" name=\"cb_distanceLimit\" />\r\n\t\t\t\t\t<input type=\"hidden\" name=\"cb_nojs\" value=\"1\" />\r\n\t\t\t\t\t<input type=\"hidden\" id=\"cb_productIds\" value=\"\" name=\"cb_productIds\" />\r\n\t\t\t\t\t<div id=\"Citybreak_bookingform\">\r\n\t\t\t\t\t\t<div class=\"cb_copy cb_clr\">\r\n\t\t\t\t\t\t\t<div class=\"Citybreak_SearchBox cb_clr\">\r\n\r\n\t\t\t\t\t\t\t                                    \r\n                                \r\n<div id=\"cb_acc_wheredoyouwanttostay_cnt\" class=\"\">\r\n\r\n\r\n\t<div class=\"cb_form_row cb_ac_section_keyword \">\t    \r\n\r\n        <label class=\"cb_titlelabel\">搜寻地区，地标或酒店名称:</label>\r\n\r\n\t\t<div class=\"cb_keyword_input\"><label><input title=\"搜寻地区，地标或酒店名称\" value=\"\" type=\"text\" id=\"cb_ac_searchfield\"  name=\"wheredoyouwanttostay\" /></label></div>\r\n\t</div>\r\n\r\n\t<div id=\"cbnoresult_srch\" class=\"cb_noresults_msg\"></div>\r\n</div>\r\n\r\n\r\n\r\n\t\t\t\t\t\t\t    \r\n<style>\r\n    .hide_acc_type {\r\n        display: none !important;\r\n    }\r\n</style>\r\n\r\n\r\n\t    <div class=\"cb_form_row cb_ac_section_accomodationtype \" id=\"cb_acc_accommodationtype_cnt\">\r\n\t        <label class=\"cb_titlelabel\">住宿类型:</label> \r\n\t        <div class=\"cb_selects cb_selects_wide\">\r\n                <select id=\"cb_accommodationtype\" class=\"cb-js-accommodationtype\" name=\"cb_categoryId\"  title=\"住宿类型\">\r\n                        <option  value=\"32542\">Deluxe Chalets</option>\r\n                        <option  value=\"16616\">Hotel</option>\r\n                        <option  value=\"16617\">Residence</option>\r\n                        <option  value=\"16620\">Self-catered apartment</option>\r\n                        <option  value=\"27621\">UCPA youth hostel </option>\r\n                        <option selected value=\"16615\">所有</option>\r\n                </select>\r\n\t        </div>\r\n\t    </div>\r\n\r\n                               \r\n\r\n\t\t\t\t\t\t\t    <div class=\"cb_clr\"><span></span></div>\r\n\t\t\t\t\t\t\t\t\r\n\r\n<div id=\"cb_acc_typeofdatesearch_cnt\" style=\"display: none;\">\r\n    \r\n\t<div class=\"cb_form_row cb_ac_section_dates\">\r\n\t\t<label class=\"cb_main_formlabel\">最新搜索类型:</label>\r\n\t\t<div class=\"cb_radio\">\r\n\t\t\t<label>\r\n\t\t\t\t<input title=\"最新搜索类型\" name=\"cb_acc_typeofdatesearch\" type=\"radio\" value=\"date\" id=\"cb_acc_typeofdatesearch_date\" checked=\"checked\"/>\r\n\t\t\t\t<span class=\"cb_radio_lbl\">日期搜索</span>\r\n\t\t\t</label>\t\t\t\r\n\t\t</div>\r\n        \r\n\t\t<div class=\"cb_radio\">\t\t\t\r\n\t\t\t<label>\r\n\t\t\t\t<input title=\"一周搜索\" name=\"cb_acc_typeofdatesearch\" type=\"radio\" value=\"week\" id=\"cb_acc_typeofdatesearch_week\" />\r\n\t\t\t\t<span class=\"cb_radio_lbl\">一周搜索</span>\r\n\t\t\t</label>\t\t\t\r\n\t\t</div>\r\n\t</div>\r\n\r\n    <div class=\"cb_form_weekpicker_cnt\">\r\n        \r\n\t</div>\r\n</div>\r\n\r\n<div id=\"cb_acc_datepicker_cnt\" >\r\n    <div>\r\n\t\t    <div class=\"cb_form_row cb_2col cb_ac_section_dates\">\r\n\t\t        <div class=\"cb_col_left\">\r\n\t\t\t        <label class=\"cb_titlelabel\">入住:</label>\r\n\t\t            <div class=\"cb_date_input\">\r\n\t\t                <label>\r\n\t\t                    <span class=\"cb_acc_datefrom_label\" style=\"display: none\">\r\n                                <span class=\"cb_acc_datefrom_day\"></span>\r\n                                <span class=\"cb_acc_datefrom_month\"></span>\r\n                                <span class=\"cb_acc_datefrom_year\"></span>\r\n                            </span>    \r\n\t\t                    <input title=\"入住\" type=\"text\" id=\"cb_form_datefrom\" name=\"cb_form_datefrom\" value=\"2019/6/19\" />\r\n\t\t                </label>\r\n                        <a class=\"cp_cal_trig_from\" id=\"Citybreak_trigger_from\" title=\"入住\"></a>\r\n\t\t            </div>\r\n\t\t\t        <div class=\"cb_byline\" id=\"cb_accommodation_datefrom_byline\">&nbsp;</div>\r\n\t\t        </div>\r\n\t\t        <div class=\"cb_col_right\">\r\n\t\t\t        <label class=\"cb_titlelabel\">退房:</label>\r\n\t\t            <div class=\"cb_date_input\">\r\n\t\t                <label>\r\n                            <span class=\"cb_acc_dateto_label\" style=\"display: none\">\r\n                                <span class=\"cb_acc_dateto_day\"></span>\r\n                                <span class=\"cb_acc_dateto_month\"></span>\r\n                                <span class=\"cb_acc_dateto_year\"></span>\r\n                            </span>    \r\n                            <input title=\"退房\" type=\"text\" id=\"cb_form_dateto\" name=\"cb_form_dateto\" value=\"2019/6/26\" />\r\n\t\t                </label><a class=\"cp_cal_trig_from\" id=\"Citybreak_trigger_to\" title=\"退房\"></a>\r\n\t\t            </div>\t\t\t\t\t\t\r\n\t\t\t        <div class=\"cb_byline\" id=\"cb_accommodation_dateto_byline\">&nbsp;</div>\r\n\t\t        </div>\r\n\t        </div>\r\n\t    </div>\r\n</div>\r\n\r\n<div id=\"cb_acc_weekpicker_cnt\" class=\"cb_form_weekpicker_cont\" style=\"display: none;\">\r\n    <div>\r\n            <div class=\"cb_form_row cb_row_periodsearch\">\r\n                <span class=\"cb_main_formlabel\"><b>最新搜索类型:</b></span>\r\n                <div class=\"cb_radio\"><label><input name=\"cb-js-date-search-type\" type=\"radio\" checked value=\"0\" />日期搜索</label></div>\r\n                <div class=\"cb_radio\"><label><input name=\"cb-js-date-search-type\" type=\"radio\"  value=\"1\" />一周搜索</label></div>\r\n            </div>\r\n            <div id=\"cb-js-date-search\"  class=\"cb_form_row cb_form_chooseweek_cnt\">\r\n\t    \t<label class=\"cb_titlelabel\">日期:</label>\r\n                <div class=\"cb_selects cb_selects_wide\">\r\n                    <div class=\"cb_date_input\">\r\n                        <label>\r\n                            <input title=\"日期\" type=\"text\" id=\"cb_acc_weekpicker_date\" name=\"cb_form_dateinweek\" value=\"2019/6/19\"/>\r\n                        </label>\r\n                        <a class=\"cp_cal_trig_from\" id=\"Citybreak_trigger_dateinweek\" title=\"日期\"></a>\r\n                    </div>\r\n                </div>\r\n            </div>\r\n\r\n            <div id=\"cb-js-week-search\" class=\"cb_form_row cb_form_lenght_cnt\" style=\"display: none; padding-left: 0;\">\r\n                <label class=\"cb_titlelabel\">周:</label>\r\n                <div class=\"cb_selects cb_selects_wide\">\r\n\t\t\t\t\t<select class=\"cb-dropdown\" id=\"cb_acc_weekpicker_week\" name=\"CabinChangeWeekControl.DateForSelectedWeek\"><option value=\"2019/6/18\">周 25, 2019</option>\r\n<option value=\"2019/6/24\">周 26, 2019</option>\r\n<option value=\"2019/7/1\">周 27, 2019</option>\r\n<option value=\"2019/7/8\">周 28, 2019</option>\r\n<option value=\"2019/7/15\">周 29, 2019</option>\r\n<option value=\"2019/7/22\">周 30, 2019</option>\r\n<option value=\"2019/7/29\">周 31, 2019</option>\r\n<option value=\"2019/8/5\">周 32, 2019</option>\r\n<option value=\"2019/8/12\">周 33, 2019</option>\r\n<option value=\"2019/8/19\">周 34, 2019</option>\r\n<option value=\"2019/8/26\">周 35, 2019</option>\r\n<option value=\"2019/9/2\">周 36, 2019</option>\r\n<option value=\"2019/9/9\">周 37, 2019</option>\r\n<option value=\"2019/9/16\">周 38, 2019</option>\r\n<option value=\"2019/9/23\">周 39, 2019</option>\r\n<option value=\"2019/9/30\">周 40, 2019</option>\r\n<option value=\"2019/10/7\">周 41, 2019</option>\r\n<option value=\"2019/10/14\">周 42, 2019</option>\r\n<option value=\"2019/10/21\">周 43, 2019</option>\r\n<option value=\"2019/10/28\">周 44, 2019</option>\r\n<option value=\"2019/11/4\">周 45, 2019</option>\r\n<option value=\"2019/11/11\">周 46, 2019</option>\r\n<option value=\"2019/11/18\">周 47, 2019</option>\r\n<option value=\"2019/11/25\">周 48, 2019</option>\r\n<option value=\"2019/12/2\">周 49, 2019</option>\r\n<option value=\"2019/12/9\">周 50, 2019</option>\r\n<option value=\"2019/12/16\">周 51, 2019</option>\r\n<option value=\"2019/12/23\">周 52, 2019</option>\r\n<option value=\"2019/12/30\">周 1, 2020</option>\r\n<option value=\"2020/1/6\">周 2, 2020</option>\r\n<option value=\"2020/1/13\">周 3, 2020</option>\r\n<option value=\"2020/1/20\">周 4, 2020</option>\r\n<option value=\"2020/1/27\">周 5, 2020</option>\r\n<option value=\"2020/2/3\">周 6, 2020</option>\r\n<option value=\"2020/2/10\">周 7, 2020</option>\r\n<option value=\"2020/2/17\">周 8, 2020</option>\r\n<option value=\"2020/2/24\">周 9, 2020</option>\r\n<option value=\"2020/3/2\">周 10, 2020</option>\r\n<option value=\"2020/3/9\">周 11, 2020</option>\r\n<option value=\"2020/3/16\">周 12, 2020</option>\r\n<option value=\"2020/3/23\">周 13, 2020</option>\r\n<option value=\"2020/3/30\">周 14, 2020</option>\r\n<option value=\"2020/4/6\">周 15, 2020</option>\r\n<option value=\"2020/4/13\">周 16, 2020</option>\r\n<option value=\"2020/4/20\">周 17, 2020</option>\r\n<option value=\"2020/4/27\">周 18, 2020</option>\r\n<option value=\"2020/5/4\">周 19, 2020</option>\r\n<option value=\"2020/5/11\">周 20, 2020</option>\r\n<option value=\"2020/5/18\">周 21, 2020</option>\r\n<option value=\"2020/5/25\">周 22, 2020</option>\r\n<option value=\"2020/6/1\">周 23, 2020</option>\r\n<option value=\"2020/6/8\">周 24, 2020</option>\r\n<option value=\"2020/6/15\">周 25, 2020</option>\r\n<option value=\"2020/6/22\">周 26, 2020</option>\r\n<option value=\"2020/6/29\">周 27, 2020</option>\r\n<option value=\"2020/7/6\">周 28, 2020</option>\r\n<option value=\"2020/7/13\">周 29, 2020</option>\r\n<option value=\"2020/7/20\">周 30, 2020</option>\r\n<option value=\"2020/7/27\">周 31, 2020</option>\r\n<option value=\"2020/8/3\">周 32, 2020</option>\r\n<option value=\"2020/8/10\">周 33, 2020</option>\r\n<option value=\"2020/8/17\">周 34, 2020</option>\r\n<option value=\"2020/8/24\">周 35, 2020</option>\r\n<option value=\"2020/8/31\">周 36, 2020</option>\r\n<option value=\"2020/9/7\">周 37, 2020</option>\r\n<option value=\"2020/9/14\">周 38, 2020</option>\r\n<option value=\"2020/9/21\">周 39, 2020</option>\r\n<option value=\"2020/9/28\">周 40, 2020</option>\r\n<option value=\"2020/10/5\">周 41, 2020</option>\r\n<option value=\"2020/10/12\">周 42, 2020</option>\r\n<option value=\"2020/10/19\">周 43, 2020</option>\r\n<option value=\"2020/10/26\">周 44, 2020</option>\r\n<option value=\"2020/11/2\">周 45, 2020</option>\r\n<option value=\"2020/11/9\">周 46, 2020</option>\r\n<option value=\"2020/11/16\">周 47, 2020</option>\r\n<option value=\"2020/11/23\">周 48, 2020</option>\r\n<option value=\"2020/11/30\">周 49, 2020</option>\r\n<option value=\"2020/12/7\">周 50, 2020</option>\r\n<option value=\"2020/12/14\">周 51, 2020</option>\r\n<option value=\"2020/12/21\">周 52, 2020</option>\r\n<option value=\"2020/12/28\">周 1, 2021</option>\r\n<option value=\"2021/1/4\">周 2, 2021</option>\r\n<option value=\"2021/1/11\">周 3, 2021</option>\r\n<option value=\"2021/1/18\">周 4, 2021</option>\r\n<option value=\"2021/1/25\">周 5, 2021</option>\r\n<option value=\"2021/2/1\">周 6, 2021</option>\r\n<option value=\"2021/2/8\">周 7, 2021</option>\r\n<option value=\"2021/2/15\">周 8, 2021</option>\r\n<option value=\"2021/2/22\">周 9, 2021</option>\r\n<option value=\"2021/3/1\">周 10, 2021</option>\r\n<option value=\"2021/3/8\">周 11, 2021</option>\r\n<option value=\"2021/3/15\">周 12, 2021</option>\r\n<option value=\"2021/3/22\">周 13, 2021</option>\r\n<option value=\"2021/3/29\">周 14, 2021</option>\r\n<option value=\"2021/4/5\">周 15, 2021</option>\r\n<option value=\"2021/4/12\">周 16, 2021</option>\r\n<option value=\"2021/4/19\">周 17, 2021</option>\r\n<option value=\"2021/4/26\">周 18, 2021</option>\r\n<option value=\"2021/5/3\">周 19, 2021</option>\r\n<option value=\"2021/5/10\">周 20, 2021</option>\r\n<option value=\"2021/5/17\">周 21, 2021</option>\r\n<option value=\"2021/5/24\">周 22, 2021</option>\r\n<option value=\"2021/5/31\">周 23, 2021</option>\r\n<option value=\"2021/6/7\">周 24, 2021</option>\r\n<option value=\"2021/6/14\">周 25, 2021</option>\r\n<option value=\"2021/6/21\">周 26, 2021</option>\r\n<option value=\"2021/6/28\">周 27, 2021</option>\r\n<option value=\"2021/7/5\">周 28, 2021</option>\r\n<option value=\"2021/7/12\">周 29, 2021</option>\r\n<option value=\"2021/7/19\">周 30, 2021</option>\r\n<option value=\"2021/7/26\">周 31, 2021</option>\r\n<option value=\"2021/8/2\">周 32, 2021</option>\r\n<option value=\"2021/8/9\">周 33, 2021</option>\r\n<option value=\"2021/8/16\">周 34, 2021</option>\r\n<option value=\"2021/8/23\">周 35, 2021</option>\r\n<option value=\"2021/8/30\">周 36, 2021</option>\r\n<option value=\"2021/9/6\">周 37, 2021</option>\r\n<option value=\"2021/9/13\">周 38, 2021</option>\r\n<option value=\"2021/9/20\">周 39, 2021</option>\r\n<option value=\"2021/9/27\">周 40, 2021</option>\r\n<option value=\"2021/10/4\">周 41, 2021</option>\r\n<option value=\"2021/10/11\">周 42, 2021</option>\r\n<option value=\"2021/10/18\">周 43, 2021</option>\r\n<option value=\"2021/10/25\">周 44, 2021</option>\r\n<option value=\"2021/11/1\">周 45, 2021</option>\r\n<option value=\"2021/11/8\">周 46, 2021</option>\r\n<option value=\"2021/11/15\">周 47, 2021</option>\r\n<option value=\"2021/11/22\">周 48, 2021</option>\r\n<option value=\"2021/11/29\">周 49, 2021</option>\r\n<option value=\"2021/12/6\">周 50, 2021</option>\r\n<option value=\"2021/12/13\">周 51, 2021</option>\r\n<option value=\"2021/12/20\">周 52, 2021</option>\r\n</select>\r\n                </div>\r\n            </div>\r\n\r\n            <div class=\"cb_form_row cb_form_lenght_cnt\" >\r\n                <label class=\"cb_titlelabel\">长度:</label>\r\n\t\t\t\t<div class=\"cb_selects cb_selects_wide\">\r\n\t\t\t\t\t\r\n\t\t\t\t\t<select id=\"cb_acc_weekpicker_period\" name=\"cb_searchPeriod\" title=\"长度\">\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t<option value=\"sp-1\" >\r\n\t\t\t\t\t\t\t\tWeek\r\n\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t<option value=\"sp-2\" >\r\n\t\t\t\t\t\t\t\tShort week\r\n\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t<option value=\"sp-3\" >\r\n\t\t\t\t\t\t\t\tWeekend\r\n\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t<option value=\"hc-nights\" >\r\n\t\t\t\t\t\t\t\t夜\r\n\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\r\n\t\t\t\t\t</select>\r\n\t\t\t\t</div>\r\n            </div>\r\n\r\n        </div>\r\n</div>\r\n\r\n\r\n\r\n\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row\" id=\"cb_acc_nodates_cnt\">\r\n\t<div class=\"cb_checkbox\">\r\n\t\t<label>\r\n            <input title=\"我没有具体日期\" type=\"checkbox\" name=\"cb_nodates\" id=\"cb_nodates\" value=\"true\"  />\r\n            <span class=\"cb_checkbox_lbl\">我没有具体日期</span>\r\n\t\t</label>\r\n\t</div>\r\n</div>\r\n                                \r\n                           \r\n\r\n\r\n<div id=\"cb_acc_typeofguestsearch_cnt\" style=\"display: none;\">\r\n\t<div class=\"cb_form_row\">\r\n\t\r\n\t    <label class=\"cb_main_formlabel\">预约类型:</label>\r\n\t\t\r\n\t    <div class=\"cb_radio\">\r\n\t        <label>\r\n\t            <input title=\"本书的床\" name=\"cb_acc_typeofguestsearch\" type=\"radio\" value=\"beds\" id=\"cb_acc_typeofguestsearch_beds\"/>\r\n\t            <span class=\"cb_radio_lbl\">本书的床</span>\r\n\t        </label>\t\t\t\r\n\t    </div>\r\n\r\n\t\t<div class=\"cb_radio\">\r\n\t\t\t<label>\r\n\t\t\t\t<input title=\"客房预订\" name=\"cb_acc_typeofguestsearch\" type=\"radio\" value=\"rooms\" id=\"cb_acc_typeofguestsearch_rooms\" checked=\"checked\" />\r\n\t\t\t\t<span class=\"cb_radio_lbl\">客房预订</span>\r\n\t\t\t</label>\t\t\r\n\t\t</div>\r\n\r\n\t</div>\r\n</div>\r\n\r\n<div id=\"cb_form_guests_cont\">\r\n\t<div id=\"cb_form_beds_cont\" style=\"display: none;\">\r\n            <div id=\"cb_form_beds_moveme\">\r\n                <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n                    <label class=\"cb_titlelabel\">\r\n                        宾客:\r\n                    </label>\r\n                    <div class=\"cb_col_left\">\r\n                        <select id=\"cb_bed_numadults\" name=\"cb_bed_numadults\" title=\"成人\">\r\n                                    <option value=\"1\" >\r\n                                        1 成人\r\n                                    </option>\r\n                                    <option value=\"2\" selected=&quot;selected&quot;>\r\n                                        2 成人\r\n                                    </option>\r\n                                    <option value=\"3\" >\r\n                                        3 成人\r\n                                    </option>\r\n                                    <option value=\"4\" >\r\n                                        4 成人\r\n                                    </option>\r\n                                    <option value=\"5\" >\r\n                                        5 成人\r\n                                    </option>\r\n                                    <option value=\"6\" >\r\n                                        6 成人\r\n                                    </option>\r\n                                    <option value=\"7\" >\r\n                                        7 成人\r\n                                    </option>\r\n                                    <option value=\"8\" >\r\n                                        8 成人\r\n                                    </option>\r\n                                    <option value=\"9\" >\r\n                                        9 成人\r\n                                    </option>\r\n                                    <option value=\"10\" >\r\n                                        10 成人\r\n                                    </option>\r\n                                    <option value=\"11\" >\r\n                                        11 成人\r\n                                    </option>\r\n                                    <option value=\"12\" >\r\n                                        12 成人\r\n                                    </option>\r\n                                    <option value=\"13\" >\r\n                                        13 成人\r\n                                    </option>\r\n                                    <option value=\"14\" >\r\n                                        14 成人\r\n                                    </option>\r\n                                    <option value=\"15\" >\r\n                                        15 成人\r\n                                    </option>\r\n                                    <option value=\"16\" >\r\n                                        16 成人\r\n                                    </option>\r\n                                    <option value=\"17\" >\r\n                                        17 成人\r\n                                    </option>\r\n                                    <option value=\"18\" >\r\n                                        18 成人\r\n                                    </option>\r\n                                    <option value=\"19\" >\r\n                                        19 成人\r\n                                    </option>\r\n                                    <option value=\"20\" >\r\n                                        20 成人\r\n                                    </option>\r\n                        </select>\r\n                    </div>\r\n                    <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n                        <select id=\"cb_bed_numchild\" onchange=\"citybreakAccommodationSearchForm.onBedChildChange()\" title=\"孩子\">\r\n                                    <option value=\"0\" selected=&quot;selected&quot;>\r\n                                        0 孩子\r\n                                    </option>\r\n                                    <option value=\"1\" >\r\n                                        1 孩子\r\n                                    </option>\r\n                                    <option value=\"2\" >\r\n                                        2 孩子\r\n                                    </option>\r\n                                    <option value=\"3\" >\r\n                                        3 孩子\r\n                                    </option>\r\n                                    <option value=\"4\" >\r\n                                        4 孩子\r\n                                    </option>\r\n                        </select>\r\n                    </div>\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_bed_childage_cont\">\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_bed_childage1\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_bed_childage1\" name=\"cb_bed_childage1\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_bed_childage2\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_bed_childage2\" name=\"cb_bed_childage2\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_bed_childage3\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_bed_childage3\" name=\"cb_bed_childage3\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_bed_childage4\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_bed_childage4\" name=\"cb_bed_childage4\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n\t</div>\r\n    \r\n    <div id=\"cb_form_rooms_cont\" >\r\n        <div id=\"cb_acc_numrooms_cnt\" class=\"cb_ac_section_numrooms cb_form_row\">\r\n            <label class=\"cb_titlelabel\">\r\n                房间数:</label>\r\n            <div class=\"cb_selects cb_selects_w3\">\r\n                <select id=\"cb_numrooms\" onchange=\"citybreakAccommodationSearchForm.cb_onRoomChange();\" title=\"房间数\">\r\n                        <option value=\"1\" >\r\n                            1 房间\r\n                        </option>\r\n                        <option value=\"2\" >\r\n                            2 客房\r\n                        </option>\r\n                        <option value=\"3\" >\r\n                            3 客房\r\n                        </option>\r\n                        <option value=\"4\" >\r\n                            4 客房\r\n                        </option>\r\n                        <option value=\"5\" >\r\n                            5 客房\r\n                        </option>\r\n                </select>\r\n            </div>\r\n        </div>\r\n\r\n            <div id=\"cb_form_room1\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd1\">\r\n                    <input title=\"房间 1\" type=\"checkbox\" checked=&quot;checked&quot; class=\"cb_room_toggle\" name=\"cb_room1\" />\r\n                    房间 1\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults1\" name=\"cb_numadults1\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild1\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(1)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont1\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage11\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage11\" name=\"cb_childage11\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage12\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage12\" name=\"cb_childage12\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage13\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage13\" name=\"cb_childage13\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage14\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage14\" name=\"cb_childage14\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n            <div id=\"cb_form_room2\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd2\">\r\n                    <input title=\"房间 2\" type=\"checkbox\"  class=\"cb_room_toggle\" name=\"cb_room2\" />\r\n                    房间 2\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults2\" name=\"cb_numadults2\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild2\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(2)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" >\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont2\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage21\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage21\" name=\"cb_childage21\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage22\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage22\" name=\"cb_childage22\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage23\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage23\" name=\"cb_childage23\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage24\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage24\" name=\"cb_childage24\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n            <div id=\"cb_form_room3\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd3\">\r\n                    <input title=\"房间 3\" type=\"checkbox\"  class=\"cb_room_toggle\" name=\"cb_room3\" />\r\n                    房间 3\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults3\" name=\"cb_numadults3\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild3\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(3)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" >\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont3\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage31\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage31\" name=\"cb_childage31\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage32\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage32\" name=\"cb_childage32\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage33\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage33\" name=\"cb_childage33\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage34\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage34\" name=\"cb_childage34\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n            <div id=\"cb_form_room4\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd4\">\r\n                    <input title=\"房间 4\" type=\"checkbox\"  class=\"cb_room_toggle\" name=\"cb_room4\" />\r\n                    房间 4\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults4\" name=\"cb_numadults4\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild4\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(4)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" >\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont4\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage41\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage41\" name=\"cb_childage41\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage42\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage42\" name=\"cb_childage42\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage43\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage43\" name=\"cb_childage43\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage44\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage44\" name=\"cb_childage44\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n            <div id=\"cb_form_room5\" class=\"cb_ac_section_room\">\r\n                <div class=\"cb_roominfo_hd\" id=\"cb_room_hd5\">\r\n                    <input title=\"房间 5\" type=\"checkbox\"  class=\"cb_room_toggle\" name=\"cb_room5\" />\r\n                    房间 5\r\n                </div>\r\n\r\n\t            <div class=\"cb_form_row cb_2col cb_ac_section_room_cfg\">\r\n\t\t            <label class=\"cb_titlelabel\">\r\n\t\t                宾客:\r\n\t\t            </label>\r\n\t\t            <div class=\"cb_col_left\">\r\n\t\t\t            <select id=\"cb_numadults5\" name=\"cb_numadults5\" title=\"成人\">\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" selected=&quot;selected&quot;>\r\n\t\t\t\t                        2 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"5\" >\r\n\t\t\t\t                        5 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"6\" >\r\n\t\t\t\t                        6 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"7\" >\r\n\t\t\t\t                        7 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"8\" >\r\n\t\t\t\t                        8 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"9\" >\r\n\t\t\t\t                        9 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"10\" >\r\n\t\t\t\t                        10 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"11\" >\r\n\t\t\t\t                        11 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"12\" >\r\n\t\t\t\t                        12 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"13\" >\r\n\t\t\t\t                        13 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"14\" >\r\n\t\t\t\t                        14 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"15\" >\r\n\t\t\t\t                        15 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"16\" >\r\n\t\t\t\t                        16 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"17\" >\r\n\t\t\t\t                        17 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"18\" >\r\n\t\t\t\t                        18 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"19\" >\r\n\t\t\t\t                        19 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"20\" >\r\n\t\t\t\t                        20 成人\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t\t            <div class=\"cb_col_right cb_ac_section_room_cfg_children\">\r\n\t\t\t            <select id=\"cb_numchild5\" onchange=\"citybreakAccommodationSearchForm.onRoomChildChange(5)\" title=\"孩子\">\r\n\t\t\t\t                    <option value=\"0\" >\r\n\t\t\t\t                        0 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"1\" >\r\n\t\t\t\t                        1 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"2\" >\r\n\t\t\t\t                        2 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"3\" >\r\n\t\t\t\t                        3 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t\t                    <option value=\"4\" >\r\n\t\t\t\t                        4 孩子\r\n\t\t\t\t                    </option>\r\n\t\t\t            </select>\r\n\t\t            </div>\r\n\t            </div>\r\n\t            <div class=\"cb_form_row cb_ac_section_room_childages\" id=\"cb_room_childage_cont5\" >\r\n\t\t            <div class=\"cb_fields cb_children\">\r\n\t\t                <label class=\"cb_titlelabel\">\r\n\t\t                    孩子们的年龄 (0-17)\r\n\t\t                </label>\r\n\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show1\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">1:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage51\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage51\" name=\"cb_childage51\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show2\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">2:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage52\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage52\" name=\"cb_childage52\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show3\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">3:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage53\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage53\" name=\"cb_childage53\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t\t                <div class=\"cb_childage_input cb_childage_show4\">\r\n\t\t\t                    <span class=\"cb_child_lbl\">4:</span>\r\n\r\n\t\t\t                    <label for=\"cb_childage54\">\r\n\t\t\t                        <input title=\"孩子们的年龄\" type=\"text\" value=\"\" id=\"cb_childage54\" name=\"cb_childage54\" maxlength=\"2\" />\r\n\t\t\t                    </label>\r\n\t\t\t                </div>\r\n\t\t            </div>\r\n\t            </div>\r\n            </div>\r\n    </div>\r\n\r\n    <div id=\"cb_form_rooms_group_cnt\" style=\"display: none;\">\r\n        <div id=\"cb_acc_numsinglerooms_group_cnt\" class=\"cb_ac_section_numsinglerooms cb_form_row\">\r\n            <label class=\"cb_titlelabel\">\r\n                号。单人间:</label>\r\n            <div class=\"cb_selects cb_selects_w3\">\r\n                <select id=\"cb_numsinglerooms_group\" title=\"号。单人间\">\r\n                        <option value=\"0\" selected=&quot;selected&quot;>\r\n                            0 客房\r\n                        </option>\r\n                        <option value=\"1\" >\r\n                            1 房间\r\n                        </option>\r\n                        <option value=\"2\" >\r\n                            2 客房\r\n                        </option>\r\n                        <option value=\"3\" >\r\n                            3 客房\r\n                        </option>\r\n                        <option value=\"4\" >\r\n                            4 客房\r\n                        </option>\r\n                        <option value=\"5\" >\r\n                            5 客房\r\n                        </option>\r\n                </select>\r\n            </div>\r\n        </div>\r\n        \r\n        <div id=\"cb_acc_numdoublerooms_group_cnt\" class=\"cb_ac_section_numdoublerooms cb_form_row\">\r\n            <label class=\"cb_titlelabel\">\r\n                号。双人间:</label>\r\n            <div class=\"cb_selects cb_selects_w3\">\r\n                <select id=\"cb_numdoublerooms_group\" title=\"号。双人间\">\r\n                        <option value=\"0\" >\r\n                            0 客房\r\n                        </option>\r\n                        <option value=\"1\" selected=&quot;selected&quot;>\r\n                            1 房间\r\n                        </option>\r\n                        <option value=\"2\" >\r\n                            2 客房\r\n                        </option>\r\n                        <option value=\"3\" >\r\n                            3 客房\r\n                        </option>\r\n                        <option value=\"4\" >\r\n                            4 客房\r\n                        </option>\r\n                        <option value=\"5\" >\r\n                            5 客房\r\n                        </option>\r\n                </select>\r\n            </div>\r\n        </div>\r\n    </div>\r\n</div>\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_showas_radiolist\">\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t\t<input name=\"cb_showon\" type=\"radio\" value=\"list\" id=\"cb_acc_showon_list\" checked=\"checked\" title=\"显示列表\" />\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_icon cb_showaslist\" title=\"显示列表\"></span>\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">在列表中显示结果</span>\r\n\t\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"cb_showon\" value=\"map\" id=\"cb_acc_showon_map\" title=\"显示地图\" />\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_icon cb_showasmap\" title=\"显示地图\"></span>\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">在地图上显示结果</span>\r\n\t\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\r\n\t\t\t\t\t\t<div class=\"cb_btn cb_clr\">\r\n\t\t\t\t\t\t\t<a href=\"#\" class=\"Citybreak_Button cb_searchbutton\" id=\"CB_SearchButton\" title=\"住宿搜索\">住宿搜索</a>\r\n\t\t\t\t\t\t\t<a href=\"#\" class=\"Citybreak_Button cb_searchbutton\" id=\"CB_SearchButtonNodates\" title=\"住宿搜索\">住宿搜索</a>\r\n\t\t\t\t\t\t\t<input type=\"submit\" value=\"住宿搜索\" id=\"cb_ns_submitbtn\" class=\"cb_ns_submitbtn\" title=\"住宿搜索\" />\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n</form>\t\t\t</div>\r\n\t\t\t<div class=\"cb_ft\"></div>\r\n\t\t</div>\r\n\t</div>\r\n</div>\r\n\r\n\t\t\t\t</div>\r\n\t\t\t\t<div class=\"cb_widget cb_eventsearchform cb_hidden\">\r\n\t\t\t\t\t<h2>搜索和书籍事件</h2>\r\n\r\n<div class=\"Citybreak_engine\">\r\n\t<div class=\"Citybreak_SidebarBox Citybreak_Search cb_event_searchbox\">\r\n\t\t<div class=\"cb_inner\">\r\n\t\t\t<div class=\"cb_ex\"></div>\r\n\t\t\t<div class=\"cb_hd\">\r\n\t\t\t\t<h4>搜索与预订</h4>\r\n\t\t\t\t<span class=\"cb_ex_label\" title=\"事件\">事件</span>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_bd\">\r\n\t\t\t\t<form action=\"http://online3-next.citybreak.com/537027515/zh/eventsearch/search?redirto=Start\" method=\"post\" id=\"cb_ev_bookingform\" >\t\r\n\t\t\t\t\t<div class=\"cb_copy cb_clr\">\r\n\t\t\t\t\t\t<div class=\"Citybreak_SearchBox\">\r\n\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ev_section_keyword\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">文本搜索:</label>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_keyword_input\"><label><input type=\"text\" id=\"cb_ev_searchfield\" name=\"s\" /></label></div>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_byline\">标题，艺术家或自由文本</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ev_section_area\">\r\n\t\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">位置:</label>\r\n\t\t\t\t\t\t\t\t\t\t\t<a id=\"cb_show_mapview_event\" class=\"cb_show_mapview\" href=\"javascript:;\">显示地图</a>\r\n\t\t\t\t\t\t\t\t\t\t<div class=\"cb_selects cb_selects_wide\">\r\n\t\t\t\t\t\t\t\t\t\t\t<select id=\"cb_ev_geoId\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"-1\">所有</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"68788\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tVal Thorens\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"67093\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tQuarter Arolles\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"67096\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tQuarter Plein Sud\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"68228\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tQuarter Balcons\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"68229\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tQuarter Caron\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"68230\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tQuarter Lombarde\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"68231\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tQuarter P&#233;clet\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"68232\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tQuarter Slalom\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"68233\">\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tQuarter Soleil\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t</option>\r\n\t\t\t\t\t\t\t\t\t\t\t</select>\r\n\t\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t<div class=\"cb_clr\"><span></span></div>\r\n                                    <div class=\"cb_form_row cb_ev_section_category\">\r\n                                        <label class=\"cb_titlelabel\">类别:</label>\r\n                                        <div class=\"cb_selects cb_selects_wide\">\r\n                                            <select id=\"cb_ev_category\" name=\"c\">\r\n                                                <option>所有</option>\r\n                                                    <option value=\"28293\">Transfer</option>\r\n                                            </select>\r\n                                        </div>\r\n                                    </div>\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ev_section_datepicker\">\r\n\t\t\t\t\t\t\t\t<div class=\"cb_col_left_w2 cb_selects_w4\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">从:</label>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_date_input\">\r\n\t\t\t\t\t\t\t\t\t    <label>\r\n                                            <span class=\"cb_ev_datefrom_label\" style=\"display: none;\">\r\n                                                <span class=\"cb_ev_datefrom_day\"></span>\r\n                                                <span class=\"cb_ev_datefrom_month\"></span>\r\n                                                <span class=\"cb_ev_datefrom_year\"></span>\r\n                                            </span> \r\n\t\t\t\t\t\t\t\t\t        <input type=\"text\" id=\"cb_ev_form_datefrom\" name=\"start\" class=\"cb_validate_startdate cb_validate_required\" value=\"2019-06-18\"/>\r\n\t\t\t\t\t\t\t\t\t    </label>\r\n\t\t\t\t\t\t\t\t\t\t<a class=\"cp_cal_trig_from\" id=\"cb_ev_trigger_from\"></a>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row cb_ev_section_lenght\">\r\n\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"period\" value=\"\" checked='checked' />\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">及之后数日</span>\r\n\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"period\" value=\"d\"  />\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">仅选定日期</span>\r\n\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"period\" value=\"w\"  />\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">一周</span>\r\n\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"period\" value=\"t\"  />\r\n\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">直至</span>\r\n\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t<div class=\"cb_form_row\" id=\"cb_ev_dateto_container\" style=\"display:none;\">\r\n\t\t\t\t\t\t\t\t<div class=\"cb_col_left_w2 cb_selects_w4\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">至:</label>\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_date_input\">\r\n\t\t\t\t\t\t\t\t\t    <label>\r\n                                            <span class=\"cb_ev_dateto_label\" style=\"display: none;\">\r\n                                                <span class=\"cb_ev_dateto_day\"></span>\r\n                                                <span class=\"cb_ev_dateto_month\"></span>\r\n                                                <span class=\"cb_ev_dateto_year\"></span>\r\n                                            </span>\r\n\t\t\t\t\t\t\t\t\t        <input type=\"text\" id=\"cb_ev_form_dateto\" class=\"cb_validate_enddate\" name=\"end\"/>\r\n\t\t\t\t\t\t\t\t\t    </label>\r\n\t\t\t\t\t\t\t\t\t\t<a class=\"cp_cal_trig_from\" id=\"cb_ev_trigger_to\"></a>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t<div class=\"cb_btn cb_clr\" id=\"cb_ev_srch_btn1\">\r\n\t\t\t\t\t\t<input type=\"submit\" class=\"Citybreak_Button cb_searchbutton\" id=\"cb_ev_SearchButton\" value=\"搜索\" />\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</form>\r\n\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_ft\"></div>\r\n\t\t</div>\r\n\t</div>\r\n</div>\r\n\r\n\t\t\t\t</div>\r\n\t\t</div>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_multi_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_multi_searchform_widget, executing inline widget scripts');





                var accommodationUrls = {};
                var accommodationSearchLocalizedTexts = {};
                (function ($, accommodationUrls, accommodationSearchLocalizedTexts, undefined) {
                    citybreakjq("#cb_acc_wheredoyouwanttostay_cnt").removeClass('cb_hidden');

                    citybreakjq.extend(accommodationUrls, {
                        'whereDoYouWantToGoJSON': 'http://online3-next.citybreak.com/537027515/zh/accommodation/wheredoyouwanttogo',
                        'whereDoYouWantToGoFilterUrl': 'http://online3-next.citybreak.com/537027515/zh/where-do-you-want-to-go/accommodationfilter',
                        'whereDoYouWantToGoSearchUrl': 'http://online3-next.citybreak.com/537027515/zh/where-do-you-want-to-go/accommodationsearch'
                    });

                    citybreakjq.extend(accommodationSearchLocalizedTexts, {
                        'AutoCompleteByLineTheresMore': '还有更多的结果',
                        'AutoCompleteNoResults': '0匹配。',
                        'AutoCompleteResultPointOfInterestCategory': '地标'
                    });


                })(citybreakjq, accommodationUrls, accommodationSearchLocalizedTexts);
                (function ($, undefined) {
                    $("#cb_accommodationtype").data("categoryRelations", [{ "Name": "Deluxe Chalets", "Id": 32542, "Relations": 0 }, { "Name": "Hotel", "Id": 16616, "Relations": 0 }, { "Name": "Residence", "Id": 16617, "Relations": 0 }, { "Name": "Self-catered apartment", "Id": 16620, "Relations": 0 }, { "Name": "UCPA youth hostel ", "Id": 27621, "Relations": 0 }, { "Name": "所有", "Id": 16615, "Relations": 0 }]);

                })(citybreakjq);
                (function ($, accommodationUrls, accommodationSearchLocalizedTexts, undefined) {


                    citybreakjq('#cb_ns_submitbtn').css('display', 'none');

                    citybreakjq.extend(accommodationUrls, {
                        'newSearch': 'http://online3-next.citybreak.com/537027515/zh/accommodationsearch/search',
                        'newFilter': 'http://online3-next.citybreak.com/537027515/zh/accommodationsearch/filter'
                    });

                    var fallbackFormComponents = 119;
                    var categoryToFormComponents = { "16615": 55, "16616": 55, "16617": 55, "16620": 55, "27621": 55, "32542": 55 };
                    var allCategoriesMapped = { "16615": { "CategoryId": 16615, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "16616": { "CategoryId": 16616, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "16617": { "CategoryId": 16617, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "16620": { "CategoryId": 16620, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "27621": { "CategoryId": 27621, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" }, "32542": { "CategoryId": 32542, "FormType": 55, "StartDate": "2019-06-19T00:00:00+02:00", "EndDate": "2019-06-26T00:00:00+02:00" } };

                    var validationMessages = {};

                    validationMessages.InvalidGeoNodeOption = "Invalid geonode selected";
                    validationMessages.InvalidCheckInDate = "无效的入住日期";
                    validationMessages.InvalidCheckOutDate = "无效的退房日期";

                    validationMessages.CheckInDateHasPassed = "入住日期已过";
                    validationMessages.CheckOutDateHasPassed = "退房日期已过";

                    validationMessages.CheckOutDateShouldBeGreaterThanCheckinDate = "入住日期必须在退房日期前";

                    validationMessages.GroupRoomBookingOneRoomRequired = "At least one room is required";
                    validationMessages.GroupRoomBookingPleaseSelectAtMostRooms = "Please select 5 rooms";
                    validationMessages.GroupRoomBookingTooManyRooms = "To many rooms selected 5";
                    validationMessages.InvalidChildAges = "有效的婴儿年龄为0到17年";
                    validationMessages.PleaseFillInChildAges = "请填写每个儿童的年龄";
                    validationMessages.PleaseChooseWhereDoYouWantToGoOrLeaveEmpty = "类型目的地城市或地标";
                    validationMessages.InvalidPromotionCode = '无效';
                    validationMessages.InvalidSearchCharacter = "Invalid search character";

                    validationMessages.Day = "夜";
                    validationMessages.Days = "夜";
                    validationMessages.CookieAlert = "Warning! Cookies are disabled. ";

                    var accCfg = citybreakCommonSearchForm.getAccommodationSearchConfiguration(
                        new Date(2019, 5, 19, 0, 0, 0, 0),
                        new Date(2019, 5, 26, 0, 0, 0, 0),
                        "2",
                        16615,
                        new Date(2019, 5, 19, 0, 0, 0, 0)
                    );

                    var filterSettings = {};

                    filterSettings.isLockedByCategory = false;



                    filterSettings.categoryId = 16615;



                    var validationSettings = {};
                    validationSettings.RequireWhereDoYouWantToGo = false;
                    validationSettings.MaximumChildAge = 17;
                    validationSettings.MinimumChildAge = 0;

                    var optionSettings = {};
                    optionSettings.MaxNumberOfRooms = 5;
                    optionSettings.MaxNumberOfChildren = 5;
                    optionSettings.minDays = 1;
                    optionSettings.minDate = new Date(2019, 5, 19, 0, 0, 0, 0);
                    optionSettings.selectedDate = new Date(2019, 5, 19, 0, 0, 0, 0);
                    optionSettings.AddNumberOfDays = 7;
                    optionSettings.ShowPromoCodeField = false;
                    optionSettings.PromotionCode = '';
                    optionSettings.ValidatePromotionCodeUrl = 'http://online3-next.citybreak.com/537027515/zh/accommodationsearch/isvalidpromotioncode';
                    optionSettings.ShowGeoDropdown = false;
                    optionSettings.AllowFreetextToggle = false;
                    optionSettings.ToggleTextHtml = { freetext: '', geo: '' };



                    var searchFormUrlOverrides = {};

                    var accommodationRoomConfigOptions = {
                        minChildAge: 0,
                        maxChildAge: 17,
                        maxNoRooms: 5,
                        maxNoAdults: 20,
                        maxNoChildren: 5,
                        maxNoTotalPersons: undefined,
                        validationMessages: {
                            invalidNumberOfRooms: "Invalid number of rooms",
                            invalidNumberOfAdults: "Invalid number of adults",
                            invalidNumberOfChildren: "Invalid number of children",
                            invalidChildAge: "Specify age of children",
                            invalidNumberOfTotalPersons: "You can only search for max {0} persons at a time."
                        },
                        translations: {
                            room: "房间",
                            rooms: "客房",
                            person: "人",
                            persons: "人",
                            adult: "成人",
                            adults: "成人",
                            child: "孩子",
                            children: "孩子",
                            removeRoom: "清除",
                            addRoom: "添加房间",
                            done: "做",
                            cancel: "取消",
                            agesOfChildren: "儿童的年龄（0  -  17岁）",
                            cabin: "cabin"
                        },
                        placementRequests: [{ "IsEmpty": false, "IsValid": true, "Adults": 2, "Children": [] }]
                    };

                    citybreakAccommodationSearchForm.initializeSearchForm(
                    fallbackFormComponents,
                    categoryToFormComponents,
                    allCategoriesMapped,
                    validationMessages,
                    accCfg.arrivalDate,
                    accCfg.departureDate,
                    0,
                    accCfg.roomCfg,
                    accommodationUrls,
                    true,
                    accommodationSearchLocalizedTexts,
                    "",
                    validationSettings,
                    filterSettings,
                    optionSettings,
                    searchFormUrlOverrides,
                    "地区，地标或财产",
                    accommodationRoomConfigOptions
                    );


                    citybreakjq('#cb_sort_search').data('default_value', '名称');


                })(citybreakjq, accommodationUrls, accommodationSearchLocalizedTexts);
                (function ($, undefined) {

                    var initStartDate = new Date(2019, 5, 18, 0, 0, 0, 0);
                    var initEndDate = new Date(2019, 6, 18, 0, 0, 0, 0);
                    var minStartDate = new Date(2019, 5, 18, 13, 21, 10, 617);

                    var validationMessages = {
                        start: 'Invalid date',
                        end: 'Invalid date',
                        CookieAlert: 'Warning! Cookies are disabled. '
                    };

                    citybreakEventSearchForm.initSearchForm(initStartDate, initEndDate, minStartDate, validationMessages);

                    $('#cb_ev_SearchButton').click(function (e) {
                        e.preventDefault();
                        if ($("#cb_ev_form_datefrom").val().length > 0) {
                            citybreakEventSearchForm.post('http://online3-next.citybreak.com/537027515/zh/eventsearch/search?redirto=Start');
                        }
                    });


                    var mapViewUrl = 'http://online3-next.citybreak.com/537027515/zh/accommodationwidget/mapview';
                    $('#cb_show_mapview_event').citybreakMapView({ mapContainerSelector: '#cb_mapcontainer', mapViewUrl: mapViewUrl });



                })(citybreakjq);
                (function ($, undefined) {

                    var settings = {};
                    $('#Citybreak_MultiWidget').multiWidget(settings);


                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_multi_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_multi_searchform_widget, executing');

            var target = citybreakjq('#citybreak_multi_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_multi_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_multi_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_multi_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_multi_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_mypage_loginform_widget', function () {
            console.log('onContentReady #citybreak_mypage_loginform_widget, executing');

            var target = document.getElementById('citybreak_mypage_loginform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_mypage_loginform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_mypage_loginform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_mypage_loginform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine cb-widget-my-page\" id=\"cb_mypage_loginform_form\">\r\n\r\n    <a href=\"javascript:void(0);\" id=\"cb-js-mypage-trigger\" class=\"cb-trigger\">Open</a>    \r\n    <a href=\"http://online3-next.citybreak.com/537027515/zh/mypagewidget/getloginform\" id=\"cb-js-mypage-trigger-alt\" class=\"cb-trigger cb-alt\">Open</a>\r\n\r\n    <div  class=\"cb-position\">\r\n        <div class=\"cb-popout cb-lip-top\" id=\"cb-js-mypage-container\">\r\n            <div class=\"cb-popout-content\" id=\"cb-js-mypage-content-inner\">\r\n\t\t\t\t<div class=\"cb-zoom-anim cb-widget-my-page-content Citybreak_engine\">\r\n\t\t\t\t\t<div class=\"cb-loading-block\"></div>\r\n\t\t\t\t</div>\r\n\t\t\t</div>\r\n            <div class=\"cb-lip\"><span class=\"cb-shadow\"></span><span class=\"cb-outline\"></span></div>\r\n        </div>\r\n    </div>\r\n\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_mypage_loginform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_mypage_loginform_widget, executing inline widget scripts');





                (function ($, undefined) {


                    var options = {
                        getLoginFormUrl: 'http://online3-next.citybreak.com/537027515/zh/mypagewidget/getloginform',
                        errorHtml: '<p>Error</p>',
                        translations: {
                            loading: 'Loading your page'
                        }
                    };

                    window.citybreakMyPageWidget.init(options);



                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_mypage_loginform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_mypage_loginform_widget, executing');

            var target = citybreakjq('#citybreak_mypage_loginform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_mypage_loginform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_mypage_loginform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_mypage_loginform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_mypage_loginform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_publictransport_searchform_widget', function () {
            console.log('onContentReady #citybreak_publictransport_searchform_widget, executing');

            var target = document.getElementById('citybreak_publictransport_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_publictransport_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_publictransport_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_publictransport_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine\">\r\n    <div class=\"Citybreak_SidebarBox Citybreak_Search cb_public_transport_searchbox\">\r\n        <input Id=\"cb-js-public-transport-start-IATA-code\" Name=\"cb_dropOffCode\" id=\"cb_dropOffCode\" name=\"cb_dropOffCode\" type=\"hidden\" value=\"\" />\r\n        <input Id=\"cb-js-public-transport-start-selection\" Name=\"cb_startSelection\" id=\"cb_startSelection\" name=\"cb_startSelection\" type=\"hidden\" value=\"\" />\r\n        <input Id=\"cb-js-public-transport-start-location-name-id\" Name=\"cb_startLocationNameId\" id=\"cb_startLocationNameId\" name=\"cb_startLocationNameId\" type=\"hidden\" value=\"\" />\r\n        <input Id=\"cb-js-public-transport-end-selection\" Name=\"cb_endSelection\" id=\"cb_endSelection\" name=\"cb_endSelection\" type=\"hidden\" value=\"\" />\r\n        <input Id=\"cb-js-public-transport-end-IATA-code\" Name=\"cb_pickUpCode\" id=\"cb_pickUpCode\" name=\"cb_pickUpCode\" type=\"hidden\" value=\"\" />\r\n        <input Id=\"cb-js-public-transport-end-location-name-id\" Name=\"cb_endLocationNameId\" id=\"cb_endLocationNameId\" name=\"cb_endLocationNameId\" type=\"hidden\" value=\"\" />\r\n        <input Id=\"cb-js-public-transport-passengers\" Name=\"pr\" id=\"pr\" name=\"pr\" type=\"hidden\" value=\"\" />\r\n        <div id=\"Citybreak_public_transport_bookingform\" class=\"\" style=\"\">\r\n            <div class=\"cb_inner\">\r\n                <div class=\"cb_ex\"> </div>\r\n                <div class=\"cb_hd\">\r\n                    <h4>搜索与预订</h4>\r\n\t\t\t\t    <span class=\"cb_ex_label\" title=\"Public transport\">Public transport</span>\r\n                </div>\r\n                <div class=\"cb_bd\">\r\n                    <div id=\"Citybreak_public_transport_bookingform\" class=\"\">\r\n                        <div class=\"cb_copy cb_clr\">\r\n                            <div class=\"Citybreak_SearchBox\">\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n                                <div class=\"cb_form_row cb_ac_section_showon_list\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">旅行类型:</label>\r\n\r\n                                    <div class=\"cb_radio\">\r\n                                        <label>\r\n\r\n                                            <input Id=\"cb-js-public-transport-triptype-roundtrip\" Name=\"cb_triptype\" checked=\"checked\" id=\"cb_triptype\" name=\"cb_triptype\" type=\"radio\" value=\"roundtrip\" />\r\n                                            <span class=\"cb_radio_lbl\">往返</span>\r\n                                        </label>\r\n                                    </div>\r\n                                    <div class=\"cb_radio\">\r\n                                        <label>\r\n                                            <input Id=\"cb-js-public-transport-triptype-oneway\" Name=\"cb_triptype\" id=\"cb_triptype\" name=\"cb_triptype\" type=\"radio\" value=\"oneway\" />\r\n                                            <span class=\"cb_radio_lbl\">单程</span>\r\n                                        </label>\r\n                                    </div>\r\n                                </div>\r\n\r\n                                <div class=\"cb_form_row cb_ac_section_keyword\">\r\n                                    <label class=\"cb_titlelabel\"><strong>离开:</strong></label>\r\n                                    <div class=\"cb_keyword_input\">\r\n                                        <label>\r\n                                            <input Id=\"cb-js-public-transport-ac-leavingfrom\" Name=\"cb_public_transport_ac_leavingfrom\" class=\"cb-form-text\" id=\"cb_public_transport_ac_leavingfrom\" name=\"cb_public_transport_ac_leavingfrom\" rel=\"tipsy\" type=\"text\" value=\"\" />\r\n                                        </label>\r\n                                        <div id=\"cb_public_transport_ac_leavingfrom_noresult\" class=\"cb_noresults_msg\"></div>\r\n                                    </div>\r\n                                </div>\r\n\t\t\t\t\t\t\r\n                                <div id=\"cb_public_transport_ac_leavingfrom_noresult\" class=\"cb_noresults_msg\"></div>\t\t\r\n\r\n                                <div class=\"cb_form_row cb_ac_section_keyword\">\r\n                                    <label class=\"cb_titlelabel\"><strong>去:</strong></label>\r\n                                    <div class=\"cb_keyword_input\">\r\n                                        <label>\r\n                                            <input Id=\"cb-js-public-transport-ac-goingto\" Name=\"cb_public_transport_ac_goingto\" class=\"cb-form-text\" id=\"cb_public_transport_ac_goingto\" name=\"cb_public_transport_ac_goingto\" rel=\"tipsy\" type=\"text\" value=\"\" />\r\n                                        </label>\r\n                                        <div id=\"cb_public_transport_ac_goingto_noresult\" class=\"cb_noresults_msg\"></div>\r\n                                    </div>\r\n                                </div>\r\n\r\n                                <div id=\"cb_public_transport_ac_goingto_noresult\" class=\"cb_noresults_msg\"></div>\t\t\r\n                            \r\n                                <div class=\"cb_form_row cb_2col cb_ac_section_dates\" id=\"cb_form_public_transport_pickUpHour_cnt\" original-title=\"\">\r\n                                    <label class=\"cb_titlelabel\">出港:</label>\r\n                                    <div class=\"cb_col_left\">\r\n                                        <div class=\"cb_date_input\">\r\n                                            <label>\r\n                                                <input Id=\"cb-js-public-transport-datefrom\" Name=\"startdate\" class=\"cb-form-text\" id=\"startdate\" name=\"startdate\" rel=\"tipsy\" type=\"text\" value=\"\" />\r\n                                            </label>\r\n                                            <a class=\"cp_cal_trig_from cb_js_publictransport_trigger_from\" title=\"\"></a>\r\n                                        </div>\r\n                                    </div>\t\t\t\t\t\t\t\r\n                                    \r\n                                    <div class=\"cb_col_right\">\r\n                                        <select Name=\"starthour\" class=\"cb-form-select\" id=\"cb-js-form-public-transport-start\" name=\"hoursminutes\"><option value=\"30\">0:30</option>\r\n<option value=\"60\">1:00</option>\r\n<option value=\"90\">1:30</option>\r\n<option value=\"120\">2:00</option>\r\n<option value=\"150\">2:30</option>\r\n<option value=\"180\">3:00</option>\r\n<option value=\"210\">3:30</option>\r\n<option value=\"240\">4:00</option>\r\n<option value=\"270\">4:30</option>\r\n<option value=\"300\">5:00</option>\r\n<option value=\"330\">5:30</option>\r\n<option selected=\"selected\" value=\"360\">6:00</option>\r\n<option value=\"390\">6:30</option>\r\n<option value=\"420\">7:00</option>\r\n<option value=\"450\">7:30</option>\r\n<option value=\"480\">8:00</option>\r\n<option value=\"510\">8:30</option>\r\n<option value=\"540\">9:00</option>\r\n<option value=\"570\">9:30</option>\r\n<option value=\"600\">10:00</option>\r\n<option value=\"630\">10:30</option>\r\n<option value=\"660\">11:00</option>\r\n<option value=\"690\">11:30</option>\r\n<option value=\"720\">12:00</option>\r\n<option value=\"750\">12:30</option>\r\n<option value=\"780\">13:00</option>\r\n<option value=\"810\">13:30</option>\r\n<option value=\"840\">14:00</option>\r\n<option value=\"870\">14:30</option>\r\n<option value=\"900\">15:00</option>\r\n<option value=\"930\">15:30</option>\r\n<option value=\"960\">16:00</option>\r\n<option value=\"990\">16:30</option>\r\n<option value=\"1020\">17:00</option>\r\n<option value=\"1050\">17:30</option>\r\n<option value=\"1080\">18:00</option>\r\n<option value=\"1110\">18:30</option>\r\n<option value=\"1140\">19:00</option>\r\n<option value=\"1170\">19:30</option>\r\n<option value=\"1200\">20:00</option>\r\n<option value=\"1230\">20:30</option>\r\n<option value=\"1260\">21:00</option>\r\n<option value=\"1290\">21:30</option>\r\n<option value=\"1320\">22:00</option>\r\n<option value=\"1350\">22:30</option>\r\n<option value=\"1380\">23:00</option>\r\n<option value=\"1410\">23:30</option>\r\n<option value=\"0\">0:00</option>\r\n</select>\r\n                                    </div>\r\n                                </div>\r\n\r\n\r\n                                <div class=\"cb_form_row cb_2col cb_ac_section_dates cb-js-date-homebound\" id=\"cb_form_public_transport_dropOffHour_cnt\" original-title=\"\">\r\n\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">回归:</label>\r\n                                    <div class=\"cb_col_left\">\r\n                                        <div class=\"cb_date_input\">\r\n                                            <label>\r\n                                                <input Id=\"cb-js-public-transport-dateto\" Name=\"enddate\" class=\"cb-form-text\" id=\"enddate\" name=\"enddate\" rel=\"tipsy\" type=\"text\" value=\"\" />\r\n                                            </label>\r\n                                            <a class=\"cp_cal_trig_from cb_js_publictransport_trigger_to\" title=\"\"></a>\r\n                                        </div>\t\r\n                                    </div>\r\n\t\t\t\t\t\t\t\t\r\n                                    <div class=\"cb_col_right\">\r\n                                        <select Name=\"endhour\" class=\"cb-form-select\" id=\"cb-js-form-public-transport-end\" name=\"hoursminutes\"><option value=\"30\">0:30</option>\r\n<option value=\"60\">1:00</option>\r\n<option value=\"90\">1:30</option>\r\n<option value=\"120\">2:00</option>\r\n<option value=\"150\">2:30</option>\r\n<option value=\"180\">3:00</option>\r\n<option value=\"210\">3:30</option>\r\n<option value=\"240\">4:00</option>\r\n<option value=\"270\">4:30</option>\r\n<option value=\"300\">5:00</option>\r\n<option value=\"330\">5:30</option>\r\n<option selected=\"selected\" value=\"360\">6:00</option>\r\n<option value=\"390\">6:30</option>\r\n<option value=\"420\">7:00</option>\r\n<option value=\"450\">7:30</option>\r\n<option value=\"480\">8:00</option>\r\n<option value=\"510\">8:30</option>\r\n<option value=\"540\">9:00</option>\r\n<option value=\"570\">9:30</option>\r\n<option value=\"600\">10:00</option>\r\n<option value=\"630\">10:30</option>\r\n<option value=\"660\">11:00</option>\r\n<option value=\"690\">11:30</option>\r\n<option value=\"720\">12:00</option>\r\n<option value=\"750\">12:30</option>\r\n<option value=\"780\">13:00</option>\r\n<option value=\"810\">13:30</option>\r\n<option value=\"840\">14:00</option>\r\n<option value=\"870\">14:30</option>\r\n<option value=\"900\">15:00</option>\r\n<option value=\"930\">15:30</option>\r\n<option value=\"960\">16:00</option>\r\n<option value=\"990\">16:30</option>\r\n<option value=\"1020\">17:00</option>\r\n<option value=\"1050\">17:30</option>\r\n<option value=\"1080\">18:00</option>\r\n<option value=\"1110\">18:30</option>\r\n<option value=\"1140\">19:00</option>\r\n<option value=\"1170\">19:30</option>\r\n<option value=\"1200\">20:00</option>\r\n<option value=\"1230\">20:30</option>\r\n<option value=\"1260\">21:00</option>\r\n<option value=\"1290\">21:30</option>\r\n<option value=\"1320\">22:00</option>\r\n<option value=\"1350\">22:30</option>\r\n<option value=\"1380\">23:00</option>\r\n<option value=\"1410\">23:30</option>\r\n<option value=\"0\">0:00</option>\r\n</select>\r\n                                    </div>\r\n                                </div>\r\n                               \r\n                                <!-- section for travellers -->\r\n                                <div class=\"cb_publictransport_travellers\">\t\t\r\n                                    <div class=\"cb_form_row\">\r\n\t\t\t\t\t\t\t\t\t\t<label class=\"cb_titlelabel\">指定的旅客人数:</label>\r\n\r\n\t\t\t\t\t\t\t\t\t\t<select class=\"selector cb-form-select cb-js-passenger-selector\" id=\"travellers\" name=\"travellers\"><option value=\"1\">1 旅行者</option>\r\n<option value=\"2\">2 旅客</option>\r\n<option value=\"3\">3 旅客</option>\r\n<option value=\"4\">4 旅客</option>\r\n<option value=\"5\">5 旅客</option>\r\n</select>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\r\n                                    <div class=\"cb-js-passenger-type-container\" style=\"float: left;\">\r\n                                            <div class=\"cb-js-passenger-type\" style=\"padding-top: 5px;\">\r\n                                                \r\n                                                <select Name=\"passenger_selection\" class=\"cb-form-select\" id=\"cb-js-passenger-code\" name=\"passenger_selection\"><option value=\"140\">Adult</option>\r\n<option value=\"141\">Child</option>\r\n</select>\r\n                                            </div>  \r\n                                    </div>\r\n                                </div>\r\n                                <!-- // section for travellers -->\r\n\r\n                                <div class=\"cb_form_row\">\r\n                                    <label class=\"cb_titlelabel\">Promo code:</label>\r\n                                    <div class=\"cb_date_input\">\r\n                                        <label>\r\n                                            <input Id=\"cb-js-public-transport-promocode\" Name=\"promocode\" class=\"cb-form-text\" id=\"promocode\" name=\"promocode\" type=\"text\" value=\"\" />\r\n                                        </label>\r\n                                    </div>\r\n                                </div>\r\n\r\n                            </div>                            \r\n                        </div>\r\n                        <!-- button panel -->\r\n                        <div class=\"cb_btn cb-clr\">\r\n                            <a id=\"cb_public_transport_searchbutton\" title=\"搜索\" class=\"Citybreak_Button cb_searchbutton\">搜索</a>\r\n                        </div>\r\n                            <!-- // button panel -->\r\n                    </div>\r\n                </div>\r\n                <div class=\"cb_ft\"> </div>\r\n            </div>\r\n        </div>\r\n    </div>\r\n</div>\r\n\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_publictransport_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_publictransport_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {


                    var validationMessages = {};

                    validationMessages.EmptyDestinationLocation = '请输入你在哪里离开';
                    validationMessages.EmptyGoingToDestination = '请输入您的目的地';
                    validationMessages.SameStartAndEndIATACode = '你需要指定不同的出发和到达地点';
                    validationMessages.InvalidDepartureDate = '无效的出发日期';
                    validationMessages.DepartureDateHasPassed = '出发日期已过';
                    validationMessages.InvalidReturningDate = '无效的归期';
                    validationMessages.ReturningDateShouldBeGreaterThanDepartureDate = '返程日期必须大于出发日期';
                    validationMessages.ReturningDateHasPassed = '返程日期已过';
                    validationMessages.PleaseChooseDepartureLocation = '请选择出发位置';
                    validationMessages.PleaseChooseGoingToDestination = '请选择到达地';
                    validationMessages.PleaseChooseDifferentTimes = 'Please choose return journey later than outbound journey';

                    validationMessages.Day = '日';
                    validationMessages.Days = '天';
                    validationMessages.CookieAlert = 'Warning! Cookies are disabled. ';


                    var publicTransportSearchConfiguration = citybreakCommonSearchForm.getPublicTransportSearchConfiguration(
                    new Date(2019, 5, 18, 13, 21, 10, 664),
                    new Date(2019, 5, 19, 13, 21, 10, 664),
                    new Date(2019, 5, 18, 13, 21, 10, 664),
                    new Date(2019, 5, 18, 13, 21, 10, 664));

                    var publicTransportSearchFormUrls = {
                        "getArrivalIataSpots": 'http://online3-next.citybreak.com/537027515/zh/publictransportsearch/getarrivalspots',
                        "getDepartureIataSpots": 'http://online3-next.citybreak.com/537027515/zh/publictransportsearch/getdeparturespots',
                        "newSearch": 'http://online3-next.citybreak.com/537027515/zh/publictransportsearch/search'
                    };

                    var publicTransportSearchFormLocalizedText = {
                        "AutoCompleteNoResults": '没有结果',
                        "AutoCompleteTheresMoreByLine": 'PublicTransport.Result.Autocomplete.Byline'
                    };

                    var validationSettings = {};
                    validationSettings.RequireLeavingFrom = false;
                    validationSettings.RequireGoingTo = false;
                    validationSettings.MinimumChildAge = 1;
                    validationSettings.MaximumChildAge = 16;

                    citybreakPublicTransportSearchForm.initializeSearchForm(
                    validationMessages,
                    publicTransportSearchConfiguration.departureDate,
                    publicTransportSearchConfiguration.returnDate,
                    0,
                    publicTransportSearchFormUrls,
                    publicTransportSearchFormLocalizedText,
                    true,
                    validationSettings,
                    new Date(2019, 5, 18, 13, 21, 10, 664),
                    1,
                    '你要去哪儿来',
                    '你从哪里离开');





                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_publictransport_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_publictransport_searchform_widget, executing');

            var target = citybreakjq('#citybreak_publictransport_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_publictransport_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_publictransport_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_publictransport_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_publictransport_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_restaurant_searchform_widget', function () {
            console.log('onContentReady #citybreak_restaurant_searchform_widget, executing');

            var target = document.getElementById('citybreak_restaurant_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_restaurant_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_restaurant_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_restaurant_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine\">\r\n\t<div class=\"Citybreak_SidebarBox Citybreak_Search cb_restaurant_searchbox\">\r\n\t\t<div class=\"cb_inner\">\r\n\t\t\t<div class=\"cb_ex\"></div>\r\n\t\t\t<div class=\"cb_hd\">\r\n\t\t\t\t<h4>搜寻食物和饮料</h4>\r\n\t\t\t\t<span class=\"cb_ex_label\" title=\"餐厅\">餐厅</span>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_bd\">\r\n\t\t\t\r\n<div id=\"Citybreak_bookingdetails\" class=\"cb_hidden\">\r\n\t<div class=\"cb_search_summary\">\r\n\t\t<div class=\"cb_copy\">\r\n\t\t\t<ul>\t\t\t\r\n\r\n\r\n\t\t\t</ul>\r\n\t\t</div>\r\n\t</div>\r\n\t<div class=\"cb_btn cb_clr\">\r\n\t\t<a href=\"javascript:;\" class=\"Citybreak_change_link\" id=\"Citybreak_changebooking\" title=\"更改搜索\">\r\n\t\t\t<span class=\"cb_icon cb_expandicon\"></span><span>更改搜索</span>\r\n\t\t</a>\r\n\t</div>\r\n</div>\r\n\t\t\t\r\n\t\t\t\t<input type=\"hidden\" value=\"false\" name=\"islockedbycategory\" />\r\n\r\n\t\t\t\t<form action=\"http://online3-next.citybreak.com/537027515/zh/food-and-drink-search/search\" method=\"post\" name=\"cb_ns_res_search\">\r\n\t\t\t\t\t<div id=\"Citybreak_bookingform\">\r\n\t\t\t\t\t\t<div class=\"cb_copy cb_clr\">\r\n\t\t\t\t\t\t\t<div class=\"Citybreak_SearchBox\">\r\n\t\t\t\t\t\t        \r\n\r\n\r\n\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t<div class=\"cb_form_row cb_showas_radiolist\">\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t\t<input name=\"cb_redirto\" type=\"radio\" value=\"list\" id=\"cb_res_redirto_list\" checked=\"checked\" title=\"在列表中显示结果\" />\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_icon cb_showaslist\" title=\"在列表中显示结果\"></span>\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">在列表中显示结果</span>\r\n\t\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t\t<div class=\"cb_radio\">\r\n\t\t\t\t\t\t\t\t\t\t<label>\r\n\t\t\t\t\t\t\t\t\t\t\t<input name=\"cb_redirto\" type=\"radio\" value=\"map\" id=\"cb_res_redirto_map\" title=\"在地图上显示结果\" />\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_icon cb_showasmap\" title=\"在地图上显示结果\"></span>\r\n\t\t\t\t\t\t\t\t\t\t\t<span class=\"cb_radio_lbl\">在地图上显示结果</span>\r\n\t\t\t\t\t\t\t\t\t\t</label>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\r\n\t\t\t\t\t\t<div class=\"cb_btn cb_clr\">\r\n\t\t\t\t\t\t\t<a href=\"javascript:;\" class=\"Citybreak_Button cb_searchbutton\" id=\"CB_Restaurant_SearchButton\" title=\"搜索\">搜索</a>\r\n\t\t\t\t\t\t\t<input type=\"submit\" value=\"搜索\" id=\"cb_ns_submitbtn\" class=\"cb_ns_submitbtn\" title=\"搜索\" />\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</form>\r\n\t\t\t</div>\r\n\t\t\t<div class=\"cb_ft\"></div>\r\n\t\t</div>\r\n\t</div>\r\n</div>\r\n\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_restaurant_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_restaurant_searchform_widget, executing inline widget scripts');





                var restaurantUrls = {};
                var restaurantSearchLocalizedTexts = {};
                (function ($, restaurantUrls, restaurantSearchLocalizedTexts, undefined) {

                    $('#cb_ns_submitbtn').css('display', 'none');

                    $.extend(restaurantUrls, {
                        'newSearch': 'http://online3-next.citybreak.com/537027515/zh/food-and-drink-search/search',
                        'newFilter': 'http://online3-next.citybreak.com/537027515/zh/food-and-drink-search/filter',
                        'jsonRestaurants': 'http://online3-next.citybreak.com/537027515/zh/food-and-drink/jsonrestaurants'
                    });

                    $.extend(restaurantSearchLocalizedTexts, {
                        'SelectAllOption': '所有',
                        'SelectNoneFoundOption': '无安打',
                        'CookieAlert': 'Warning! Cookies are disabled. '
                    });

                    var validationMessages = {};

                    var filterSettings = {};
                    filterSettings.isLockedByCategory = false;





                    var validationSettings = {}; // none atm, but maybe later

                    var optionSettings = {}; // none atm, but maybe later

                    citybreakRestaurantSearchForm.initializeSearchForm(
                        restaurantUrls,
                        true,
                        restaurantSearchLocalizedTexts,
                        validationSettings,
                        filterSettings,
                        optionSettings
                    );

                    $('#cb_sort_search').data("default_value", "名称");


                })(citybreakjq, restaurantUrls, restaurantSearchLocalizedTexts);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_restaurant_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_restaurant_searchform_widget, executing');

            var target = citybreakjq('#citybreak_restaurant_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_restaurant_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_restaurant_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_restaurant_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_restaurant_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());


    (function () {


        window.citybreak = window.citybreak || {};
        window.citybreak.XDR_SESSION = "online3_537027515_zh-CHS_zh-CHS=1xei2v1gkgwjcdouixyiqnml";




        var POLL_RETRIES = 6000 * 10;
        var POLL_INTERVAL = 20;

        var pollRetries, interval, onContentReadyExecuted;



        citybreakWidgetLoader.onContentReady('citybreak_shuttletransport_searchform_widget', function () {
            console.log('onContentReady #citybreak_shuttletransport_searchform_widget, executing');

            var target = document.getElementById('citybreak_shuttletransport_searchform_widget');

            if (!target) {
                console.log('onContentReady #citybreak_shuttletransport_searchform_widget, could not find target');
                return;
            }

            if (target.getAttribute('data-loaded') !== true) {
                target.setAttribute('data-loaded', true);
                console.log('onContentReady #citybreak_shuttletransport_searchform_widget, data-loaded is false');
            } else {
                console.log('onContentReady #citybreak_shuttletransport_searchform_widget, data-loaded is true');
                return;
            }

            while (target.firstChild) {
                target.removeChild(target.firstChild);
            }

            target.classList.add('cb_js');
            target.classList.add('cb_lang_zh');

            citybreakWidgetLoader.appendHtml(target, "<div class=\"Citybreak_engine cb-widget-search\" id=\"Citybreak_shuttle_transport_bookingform\">\r\n    <input Id=\"cb-js-shuttle-transport-start-selection\" Name=\"cb_startSelection\" id=\"cb_startSelection\" name=\"cb_startSelection\" type=\"hidden\" value=\"\" />\r\n<input Id=\"cb-js-shuttle-transport-start-location-name-id\" Name=\"cb_startLocationNameId\" id=\"cb_startLocationNameId\" name=\"cb_startLocationNameId\" type=\"hidden\" value=\"\" />    <input Id=\"cb-js-shuttle-transport-end-selection\" Name=\"cb_endSelection\" id=\"cb_endSelection\" name=\"cb_endSelection\" type=\"hidden\" value=\"\" />\r\n<input Id=\"cb-js-shuttle-transport-end-location-name-id\" Name=\"cb_endLocationNameId\" id=\"cb_endLocationNameId\" name=\"cb_endLocationNameId\" type=\"hidden\" value=\"\" />    <input Id=\"cb-js-shuttle-transport-passengers\" Name=\"pr\" id=\"pr\" name=\"pr\" type=\"hidden\" value=\"\" />\r\n    <div class=\"cb-block cb-block-destination\">\r\n        <div class=\"cb-item\">\r\n            <label>\r\n\t\t\t\t<input class=\"cb_js_travelling_type\" type=\"checkbox\" />\r\n\t\t\t\t&nbsp;单程\r\n\t\t\t</label>\r\n        </div>\r\n    </div>\r\n    <div class=\"cb-block cb-block-destination\">\r\n        <div class=\"cb-item\">\r\n            <span class=\"cb-label-title\"><b>集合地点:</b></span>\r\n            <label>\r\n<input Id=\"cb-js-shuttle-transport-ac-leavingfrom\" Name=\"cb_shuttle_transport_ac_leavingfrom\" class=\"cb-form-text\" id=\"cb_shuttle_transport_ac_leavingfrom\" name=\"cb_shuttle_transport_ac_leavingfrom\" rel=\"tipsy\" type=\"text\" value=\"\" />            </label>\r\n            <div id=\"cb_shuttle_transport_ac_leavingfrom_noresult\" class=\"cb_noresults_msg\"></div>\r\n        </div>\r\n        <div class=\"cb-item\">\r\n            <span class=\"cb-label-title\"><b>投递地点:</b></span>\r\n            <label>\r\n<input Id=\"cb-js-shuttle-transport-ac-goingto\" Name=\"cb_shuttle_transport_ac_goingto\" class=\"cb-form-text\" id=\"cb_shuttle_transport_ac_goingto\" name=\"cb_shuttle_transport_ac_goingto\" rel=\"tipsy\" type=\"text\" value=\"\" />            </label>\r\n            <div id=\"cb_shuttle_transport_ac_goingto_noresult\" class=\"cb_noresults_msg\"></div>\r\n        </div>\r\n    </div>\r\n    <div class=\"cb-block cb-block-dates-time-travelers\">\r\n        <div class=\"cb-item cb-item-date-time-from\">\r\n            <span class=\"cb-label-title\"><b>航班到达:</b></span>\r\n            <label class=\"cb-form-icon cb-icon-date\">\r\n                <input Id=\"cb-js-shuttle-transport-datefrom\" Name=\"startdate\" class=\"cb-form-text\" id=\"startdate\" name=\"startdate\" rel=\"tipsy\" type=\"text\" value=\"\" />\r\n\t\t\t\t<span></span>\r\n            </label>\r\n            <label>\r\n\t\t\t\t<select Class=\"cb-form-select\" Name=\"starthour\" id=\"cb-js-form-shuttle-transport-start\" name=\"hoursminutes\"><option value=\"30\">0:30</option>\r\n<option value=\"60\">1:00</option>\r\n<option value=\"90\">1:30</option>\r\n<option value=\"120\">2:00</option>\r\n<option value=\"150\">2:30</option>\r\n<option value=\"180\">3:00</option>\r\n<option value=\"210\">3:30</option>\r\n<option value=\"240\">4:00</option>\r\n<option value=\"270\">4:30</option>\r\n<option value=\"300\">5:00</option>\r\n<option value=\"330\">5:30</option>\r\n<option value=\"360\">6:00</option>\r\n<option value=\"390\">6:30</option>\r\n<option value=\"420\">7:00</option>\r\n<option value=\"450\">7:30</option>\r\n<option value=\"480\">8:00</option>\r\n<option value=\"510\">8:30</option>\r\n<option value=\"540\">9:00</option>\r\n<option value=\"570\">9:30</option>\r\n<option value=\"600\">10:00</option>\r\n<option value=\"630\">10:30</option>\r\n<option value=\"660\">11:00</option>\r\n<option value=\"690\">11:30</option>\r\n<option selected=\"selected\" value=\"720\">12:00</option>\r\n<option value=\"750\">12:30</option>\r\n<option value=\"780\">13:00</option>\r\n<option value=\"810\">13:30</option>\r\n<option value=\"840\">14:00</option>\r\n<option value=\"870\">14:30</option>\r\n<option value=\"900\">15:00</option>\r\n<option value=\"930\">15:30</option>\r\n<option value=\"960\">16:00</option>\r\n<option value=\"990\">16:30</option>\r\n<option value=\"1020\">17:00</option>\r\n<option value=\"1050\">17:30</option>\r\n<option value=\"1080\">18:00</option>\r\n<option value=\"1110\">18:30</option>\r\n<option value=\"1140\">19:00</option>\r\n<option value=\"1170\">19:30</option>\r\n<option value=\"1200\">20:00</option>\r\n<option value=\"1230\">20:30</option>\r\n<option value=\"1260\">21:00</option>\r\n<option value=\"1290\">21:30</option>\r\n<option value=\"1320\">22:00</option>\r\n<option value=\"1350\">22:30</option>\r\n<option value=\"1380\">23:00</option>\r\n<option value=\"1410\">23:30</option>\r\n<option value=\"0\">0:00</option>\r\n</select>\r\n            </label>\r\n        </div>\r\n        <div class=\"cb-item cb-item-date-time-to cb_js_return_dates\">\r\n            <span class=\"cb-label-title\"><b>航班起飞:</b></span>\r\n            <label class=\"cb-form-icon cb-icon-date\">\r\n                <input Id=\"cb-js-shuttle-transport-returnDate\" Name=\"returndate\" class=\"cb-form-text\" id=\"returndate\" name=\"returndate\" rel=\"tipsy\" type=\"text\" value=\"\" />\r\n\t\t\t\t<span></span>\r\n            </label>\r\n            <label>\r\n\t\t\t\t<select Class=\"cb-form-select\" Name=\"returnhour\" id=\"cb-js-form-shuttle-transport-return\" name=\"hoursminutes\"><option value=\"30\">0:30</option>\r\n<option value=\"60\">1:00</option>\r\n<option value=\"90\">1:30</option>\r\n<option value=\"120\">2:00</option>\r\n<option value=\"150\">2:30</option>\r\n<option value=\"180\">3:00</option>\r\n<option value=\"210\">3:30</option>\r\n<option value=\"240\">4:00</option>\r\n<option value=\"270\">4:30</option>\r\n<option value=\"300\">5:00</option>\r\n<option value=\"330\">5:30</option>\r\n<option value=\"360\">6:00</option>\r\n<option value=\"390\">6:30</option>\r\n<option value=\"420\">7:00</option>\r\n<option value=\"450\">7:30</option>\r\n<option value=\"480\">8:00</option>\r\n<option value=\"510\">8:30</option>\r\n<option value=\"540\">9:00</option>\r\n<option value=\"570\">9:30</option>\r\n<option value=\"600\">10:00</option>\r\n<option value=\"630\">10:30</option>\r\n<option value=\"660\">11:00</option>\r\n<option value=\"690\">11:30</option>\r\n<option selected=\"selected\" value=\"720\">12:00</option>\r\n<option value=\"750\">12:30</option>\r\n<option value=\"780\">13:00</option>\r\n<option value=\"810\">13:30</option>\r\n<option value=\"840\">14:00</option>\r\n<option value=\"870\">14:30</option>\r\n<option value=\"900\">15:00</option>\r\n<option value=\"930\">15:30</option>\r\n<option value=\"960\">16:00</option>\r\n<option value=\"990\">16:30</option>\r\n<option value=\"1020\">17:00</option>\r\n<option value=\"1050\">17:30</option>\r\n<option value=\"1080\">18:00</option>\r\n<option value=\"1110\">18:30</option>\r\n<option value=\"1140\">19:00</option>\r\n<option value=\"1170\">19:30</option>\r\n<option value=\"1200\">20:00</option>\r\n<option value=\"1230\">20:30</option>\r\n<option value=\"1260\">21:00</option>\r\n<option value=\"1290\">21:30</option>\r\n<option value=\"1320\">22:00</option>\r\n<option value=\"1350\">22:30</option>\r\n<option value=\"1380\">23:00</option>\r\n<option value=\"1410\">23:30</option>\r\n<option value=\"0\">0:00</option>\r\n</select>\r\n            </label>\r\n        </div>\r\n        <div class=\"cb-item cb-item-travelers\">\r\n            <span class=\"cb-label-title\"><b>游客数:</b></span>\r\n            <label>\r\n                <select id=\"cb_numadults\" class=\"cb-js-shuttle-transport-passengers cb-form-select\" title=\"成人\">\r\n                            <option value=\"1\" >\r\n                                1 旅客\r\n                            </option>\r\n                            <option value=\"2\" selected=&quot;selected&quot;>\r\n                                2 旅客\r\n                            </option>\r\n                            <option value=\"3\" >\r\n                                3 旅客\r\n                            </option>\r\n                            <option value=\"4\" >\r\n                                4 旅客\r\n                            </option>\r\n                            <option value=\"5\" >\r\n                                5 旅客\r\n                            </option>\r\n                            <option value=\"6\" >\r\n                                6 旅客\r\n                            </option>\r\n                            <option value=\"7\" >\r\n                                7 旅客\r\n                            </option>\r\n                            <option value=\"8\" >\r\n                                8 旅客\r\n                            </option>\r\n                            <option value=\"9\" >\r\n                                9 旅客\r\n                            </option>\r\n                </select>\r\n            </label>\r\n        </div>\r\n    </div>\r\n\r\n    <div class=\"cb-actions\">\r\n        <a class=\"cb-button cb_js_shuttle_transport_search\">\r\n            <span class=\"cb-btn-inner\">搜索</span>\r\n            <span class=\"cb-btn-bg\"></span>\r\n        </a>\r\n    </div>\r\n</div>\r\n");

            onContentReadyExecuted = true;

            console.log('onContentReady #citybreak_shuttletransport_searchform_widget, complete');

        });

        function checkOnContentReady() {
            var success = false;

            if (onContentReadyExecuted) {

                console.log('doneLoadingResources #citybreak_shuttletransport_searchform_widget, executing inline widget scripts');





                (function ($, undefined) {

                    var validationMessages = {};

                    validationMessages.EmptyDestinationLocation = '请输入你在哪里离开';
                    validationMessages.EmptyGoingToDestination = '请输入您的目的地';
                    validationMessages.SameStartAndEndIATACode = '你需要指定不同的出发和到达地点';
                    validationMessages.InvalidDepartureDate = '无效的出发日期';
                    validationMessages.DepartureDateHasPassed = '出发日期已过';
                    validationMessages.InvalidReturningDate = '无效的归期';
                    validationMessages.ReturningDateShouldBeGreaterThanDepartureDate = '返程日期必须大于出发日期';
                    validationMessages.ReturningDateHasPassed = '返程日期已过';
                    validationMessages.PleaseChooseDepartureLocation = '请选择出发位置';
                    validationMessages.PleaseChooseGoingToDestination = '请选择到达地';

                    validationMessages.Day = '日';
                    validationMessages.Days = '天';
                    validationMessages.CookieAlert = 'Warning! Cookies are disabled. ';

                    var validationSettings = {};
                    validationSettings.RequireLeavingFrom = true;
                    validationSettings.RequireGoingTo = true;
                    validationSettings.MinimumChildAge = 1;
                    validationSettings.MaximumChildAge = 16;

                    var shuttleTransportSearchConfiguration = citybreakCommonSearchForm.getPublicTransportSearchConfiguration(
                    new Date(2019, 5, 18, 13, 21, 10, 680),
                    new Date(2019, 5, 19, 13, 21, 10, 680),
                    new Date(2019, 5, 18, 13, 21, 10, 695),
                    new Date(2019, 5, 18, 13, 21, 10, 680)
                    );
                    var shuttleTransportSearchFormUrls = {
                        "getArrivalIataSpots": 'http://online3-next.citybreak.com/537027515/zh/shuttletransportsearch/getarrivalspots',
                        "getDepartureIataSpots": 'http://online3-next.citybreak.com/537027515/zh/shuttletransportsearch/getdeparturespots',
                        "newSearch": 'http://online3-next.citybreak.com/537027515/zh/shuttletransportsearch/search'
                    };
                    var shuttleTransportSearchFormLocalizedText = {
                        "AutoCompleteNoResults": '没有结果',
                        "AutoCompleteTheresMoreByLine": 'PublicTransport.Result.Autocomplete.Byline'
                    };
                    window.citybreakShuttleTransportSearchForm.initialize(
                        shuttleTransportSearchConfiguration.departureDate,
                        shuttleTransportSearchConfiguration.returnDate,
                        new Date(2019, 5, 18, 13, 21, 10, 680),
                        1,
                        shuttleTransportSearchFormUrls,
                        shuttleTransportSearchFormLocalizedText,
                        0,
                        '你要去哪儿来',
                        '你从哪里离开',
                        validationMessages,
                        validationSettings,
                        false,
                        false);


                })(citybreakjq);
                (function ($, undefined) {

                })(citybreakjq);



                success = true;

                console.log('doneLoadingResources #citybreak_shuttletransport_searchform_widget, executed inline widget scripts');

                citybreak.setExternalUrlHandler();

                try {
                    citybreak_widget_loaded();
                }
                catch (e) {

                }
            }

            pollRetries--;

            if (success || pollRetries <= 0) {
                interval = window.clearInterval(interval);
            }
        }

        function doneLoadingResources() {

            console.log('doneLoadingResources #citybreak_shuttletransport_searchform_widget, executing');

            var target = citybreakjq('#citybreak_shuttletransport_searchform_widget');

            if (target.length === 0) {
                console.log('doneLoadingResources #citybreak_shuttletransport_searchform_widget, could not find target');
                return;
            }

            if (target.data("loaded-js") !== true) {
                target.data("loaded-js", true);
                console.log('doneLoadingResources #citybreak_shuttletransport_searchform_widget, data-loaded is false');
            } else {
                console.log('doneLoadingResources #citybreak_shuttletransport_searchform_widget, data-loaded is true');
                return;
            }

            if (!interval) {
                pollRetries = POLL_RETRIES;
                interval = window.setInterval(checkOnContentReady, POLL_INTERVAL);
            }

            console.log('doneLoadingResources #citybreak_shuttletransport_searchform_widget, complete');

        }

        window.citybreakWidgetLoader.doneLoadingResources.push(doneLoadingResources);

    }());



    function doneLoadingResources() {

        for (var c = 0; c < window.citybreakWidgetLoader.doneLoadingResources.length; c++) {
            try {
                var callback = window.citybreakWidgetLoader.doneLoadingResources[c];

                callback();
            }
            catch (e) {

            }
        }

        citybreakjq.subscribe("/widget/setexternalurl/", citybreak.setExternalUrlHandler);

        try {
            citybreak_combine_widget_loaded();
        }
        catch (e) {

        }
    }


    (function (citybreak, undefined) {
        citybreak.culture = 'zh-CHS';

        var cbSettings = window.citybreak.settings = window.citybreak.settings || {};

    }(window.citybreak = window.citybreak || {}));






    citybreakWidgetLoader.loadCss('http://online3-next.citybreak.com/537027515/zh/style/css/searchformwidget_styles.css');
    citybreakWidgetLoader.loadCss('http://online3-next.citybreak.com/537027515/zh/style/css/popularwidget_styles.css');
    citybreakWidgetLoader.loadCss('http://online3-next.citybreak.com/537027515/zh/style/css/activity_book_widget.css');
    citybreakWidgetLoader.loadCss('http://online3-next.citybreak.com/537027515/zh/style/css/compactbasket_styles.css');
    citybreakWidgetLoader.loadCss('http://online3-next.citybreak.com/537027515/zh/style/css/minibasket_styles.css');
    citybreakWidgetLoader.loadCss('http://online3-next.citybreak.com/537027515/zh/style/css/widget_my_page.css');

    citybreakWidgetLoader.$LAB
        .script('http://online3-next.citybreak.com/537027515/zh/content/combinedjs/app-c8e28fb3.js').wait()

        .wait(function () {
            doneLoadingResources();
        });



})();