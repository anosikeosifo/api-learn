package com.brownlilac.galleriaafrique;

import android.app.Fragment;
import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

/**
 * Created by Splashers on 10/12/2014.
 */
public class DetailsFragment extends Fragment {

    private TextView textUser, textDescriptionn, textCreateAt;


    public DetailsFragment() {
        super();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        //return super.onCreateView(inflater, container, savedInstanceState);

        View view = inflater.inflate(R.layout.list_item, null, false );
        textUser = (TextView) view.findViewById(R.id.post_username);
        textDescriptionn = (TextView) view.findViewById(R.id.post_title);
        textCreateAt = (TextView) view.findViewById(R.id.post_created_at);

        return view;
    }
    @Override
    public void onResume() {
        super.onResume();

        long id = getActivity().getIntent().getLongExtra(PostContract.Column.ID, -1);

        updateView(id);
    }


    public void updateView(long id){
        if(id == -1){
            textUser.setText("");
            textDescriptionn.setText("");
            textCreateAt.setText("");


            return;
        }

        Uri uri = ContentUris.withAppendedId(PostContract.CONTENT_URI, id);

        Cursor cursor = getActivity().getContentResolver().query(uri, null, null, null, null);

        if(!cursor.moveToFirst())
            return;

        String user = cursor.getString(cursor.getColumnIndex(PostContract.Column.ID));
        String message = cursor.getString(cursor.getColumnIndex(PostContract.Column.TITLE));
        long createdAt = cursor.getLong(cursor.getColumnIndex(PostContract.Column.CREATED_AT));

        textUser.setText(user);
        textDescriptionn.setText(message);
        textCreateAt.setText(DateUtils.getRelativeTimeSpanString(createdAt));
    }
}
