<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>D
  <partialquery name="parent_context_all">
    <querytext>
      fs_objects.object_id in (select item_id from cr_items where
      tree_sortkey between (select tree_sortkey from cr_items where
      item_id = :folder_id) and (select tree_right(tree_sortkey) from
      cr_items where item_id = :folder_id)
    </querytext>
  </partialquery>
    
  <fullquery name="select_folder_contents">
        <querytext>

            select fs_objects.object_id,
                   fs_objects.name,
                   fs_objects.live_revision,
                   fs_objects.type,
     	           fs_objects.pretty_type,
                   to_char(fs_objects.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified_ansi,
                   fs_objects.content_size,
                   fs_objects.url,
                   fs_objects.sort_key,
                   fs_objects.file_upload_name,
                   coalesce(fs_objects.title,fs_objects.name) as title,
	--	    fs_objects.description,
                   case
                     when :folder_path is null
                     then fs_objects.file_upload_name
                     else :folder_path || '/' || fs_objects.file_upload_name
                   end as file_url --,
--                   fs_objects.html_description
            from fs_objects
            where fs_objects.parent_id = :folder_id
	$permission_clause
--              and fs_objects.approved_p = 't'
--             and ((fs_objects.active_date_start is null) or (current_timestamp >= fs_objects.active_date_start))
--            and ((fs_objects.active_date_end is null) or (current_timestamp <= fs_objects.active_date_end))
              $object_list_where
	order by fs_objects.sort_key, fs_objects.name 
--            order by fs_objects.sort_key, fs_objects.order_n, fs_objects.name

        </querytext>
    </fullquery>

    <fullquery name="get_folder_path">
        <querytext>
                select content_item__get_path(:folder_id, :root_folder_id)
        </querytext>
    </fullquery>

</queryset>
