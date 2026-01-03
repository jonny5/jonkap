/**
 * Footnotes.js - Hover popups for Jekyll/Kramdown footnotes
 * Inspired by gwern.net
 *
 * Hover over reference: Popup appears
 * Click reference: Navigate to bottom footnote
 */

(function() {
    'use strict';

    const Footnotes = {
        config: {
            hoverDelay: 350,
            fadeoutDelay: 200,
            fadeoutDuration: 150,
            popupOffset: 8,
        },

        // Popups state
        popupContainer: null,
        currentPopup: null,
        hoverTimer: null,
        fadeoutTimer: null,

        init: function() {
            console.log('Footnotes: Initializing...');
            this.createPopupContainer();
            this.setupPopupBehavior();
            console.log('Footnotes: Initialized');
        },

        /* ==========================================
           POPUPS (hover to show)
           ========================================== */

        createPopupContainer: function() {
            if (document.querySelector('#footnote-popup-container')) {
                return;
            }

            this.popupContainer = document.createElement('div');
            this.popupContainer.id = 'footnote-popup-container';
            document.body.appendChild(this.popupContainer);
        },

        setupPopupBehavior: function() {
            const footnoteRefs = document.querySelectorAll('a.footnote, sup a[href^="#fn"]');

            footnoteRefs.forEach(ref => {
                // Hover events for popup
                ref.addEventListener('mouseenter', (e) => this.onFootnoteHover(e, ref));
                ref.addEventListener('mouseleave', (e) => this.onFootnoteLeave(e, ref));

                // Touch support for mobile
                ref.addEventListener('touchstart', (e) => this.onFootnoteTouchStart(e, ref), { passive: true });

                // Click navigates to bottom (default behavior preserved)
            });
        },

        onFootnoteHover: function(e, ref) {
            clearTimeout(this.hoverTimer);
            clearTimeout(this.fadeoutTimer);

            this.hoverTimer = setTimeout(() => {
                this.showPopup(ref);
            }, this.config.hoverDelay);
        },

        onFootnoteLeave: function(e, ref) {
            clearTimeout(this.hoverTimer);

            const relatedTarget = e.relatedTarget;
            if (relatedTarget && relatedTarget.closest('.footnote-popup')) {
                return;
            }

            this.scheduleHidePopup();
        },

        onFootnoteTouchStart: function(e, ref) {
            if (this.currentPopup && this.currentPopup.dataset.refId === ref.id) {
                this.hidePopup();
                return;
            }

            e.preventDefault();
            this.showPopup(ref);
        },

        showPopup: function(ref) {
            const footnoteId = ref.getAttribute('href').substring(1);
            const footnoteDef = document.getElementById(footnoteId);

            if (!footnoteDef) {
                return;
            }

            this.hidePopup(true);

            const popup = document.createElement('div');
            popup.className = 'footnote-popup';
            popup.dataset.refId = ref.id || footnoteId;

            const content = footnoteDef.cloneNode(true);
            const backlink = content.querySelector('.reversefootnote, a[href^="#fnref"]');
            if (backlink) {
                backlink.remove();
            }

            popup.appendChild(content);

            popup.addEventListener('mouseenter', () => {
                clearTimeout(this.fadeoutTimer);
            });

            popup.addEventListener('mouseleave', () => {
                this.scheduleHidePopup();
            });

            this.popupContainer.appendChild(popup);
            this.currentPopup = popup;

            this.positionPopup(popup, ref);

            requestAnimationFrame(() => {
                popup.classList.add('visible');
            });

            ref.classList.add('popup-open');
        },

        positionPopup: function(popup, ref) {
            const refRect = ref.getBoundingClientRect();
            const popupRect = popup.getBoundingClientRect();
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
            const scrollLeft = window.pageXOffset || document.documentElement.scrollLeft;

            let top = refRect.bottom + scrollTop + this.config.popupOffset;
            let left = refRect.left + scrollLeft;

            if (refRect.bottom + popupRect.height + this.config.popupOffset > window.innerHeight) {
                top = refRect.top + scrollTop - popupRect.height - this.config.popupOffset;
            }

            if (left + popupRect.width > window.innerWidth + scrollLeft - 20) {
                left = window.innerWidth + scrollLeft - popupRect.width - 20;
            }

            if (left < scrollLeft + 10) {
                left = scrollLeft + 10;
            }

            popup.style.top = top + 'px';
            popup.style.left = left + 'px';
        },

        scheduleHidePopup: function() {
            clearTimeout(this.fadeoutTimer);

            this.fadeoutTimer = setTimeout(() => {
                this.hidePopup();
            }, this.config.fadeoutDelay);
        },

        hidePopup: function(immediate = false) {
            clearTimeout(this.hoverTimer);
            clearTimeout(this.fadeoutTimer);

            if (!this.currentPopup) {
                return;
            }

            document.querySelectorAll('a.footnote.popup-open, sup a[href^="#fn"].popup-open').forEach(ref => {
                ref.classList.remove('popup-open');
            });

            if (immediate) {
                this.currentPopup.remove();
                this.currentPopup = null;
            } else {
                const popup = this.currentPopup;
                popup.classList.remove('visible');

                setTimeout(() => {
                    if (popup.parentNode) {
                        popup.remove();
                    }
                    if (this.currentPopup === popup) {
                        this.currentPopup = null;
                    }
                }, this.config.fadeoutDuration);
            }
        }
    };

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => Footnotes.init());
    } else {
        Footnotes.init();
    }

    window.Footnotes = Footnotes;
})();
