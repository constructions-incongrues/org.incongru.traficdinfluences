<?php
/**
 * Enqueue scripts and styles.
 */
function traficdinfluences_enqueue_scripts() {
	$parent_style = 'hexo-style';
	wp_enqueue_style( 'bootstrap', get_template_directory_uri() . '/layouts/bootstrap.css' );
	wp_enqueue_style( 'menu', get_template_directory_uri() . '/layouts/hamburgers.css' );
	wp_enqueue_style( $parent_style, get_template_directory_uri() . '/style.css' );
	wp_enqueue_style( 'hexo-traficdinfluences-style',
		get_stylesheet_directory_uri() . '/style.css',
		[$parent_style],
		wp_get_theme()->get('Version')
	);
}
add_action( 'wp_enqueue_scripts', 'traficdinfluences_enqueue_scripts' );
