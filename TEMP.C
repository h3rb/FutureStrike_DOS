void CreateObj( OBJ_DATA obj, OBJ_DATA *list, int num )
{
    OBJ_DATA *temp;

    if ( freehead == NULL )
    {
        temp           = alloc_perm( sizeof(*temp) );
    }
    else
    {
        temp           = freehead;
        freehead       = freehead->next;
    }

    temp->next = list;
    list = temp;
    num++;
    return;
}

void MoveObj( OBJ_DATA *node, OBJ_DATA *slist, OBJ_DATA *tlist, int s, int t )
{
    OBJ_DATA *prev;

    if ( node == slist )
    {
         slist      = slist->next;
         node->next = tlist;
         tlist      = node;
         s--;
         t++;
    }
    else
    {
    for ( prev = slist; prev->next != node; prev = prev->next )
    {
        if ( prev->next == NULL )
        bug( "FreeObj: not in list", 0 );
    }

    prev->next = node->next;

    node->next = tlist;
    tlist      = node;
    prev       = prev->next;
    s--;
    t++;
    }

    return;
}

